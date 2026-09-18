import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:dio/dio.dart';
import '../config/app_config.dart';

import '../../features/address/domain/entities/map_location_entities.dart';
import '../utils/placemark_extension.dart';

class MapLocationService {
  MapLocationService({Geocoding? geocoding})
      : _geocoding = geocoding ?? Geocoding();

  final Geocoding _geocoding;

  static const int _maxSearchResults = 5;

  // Session-scoped search cache
  static final Map<String, List<MapSearchResult>> _searchCache = {};

  Timer? _searchDebounce;
  Timer? _reverseGeocodeDebounce;

  int _searchRequestId = 0;
  int _geocodeRequestId = 0;

  LatLng? _lastGeocodedPosition;
  bool _isGeocoding = false;

  bool get isGeocoding => _isGeocoding;

  // ─── Lifecycle ───────────────────────────────────────────────

  void cancelPendingWork() {
    _searchDebounce?.cancel();
    _reverseGeocodeDebounce?.cancel();
    _searchRequestId++;
    _geocodeRequestId++;
  }

  // ─── Forward geocode (search) ────────────────────────────────

  void scheduleAddressSearch({
    required String query,
    required void Function(List<MapSearchResult> results) onResults,
    Duration debounce = const Duration(milliseconds: 500),
  }) {
    _searchDebounce?.cancel();
    if (query.trim().length < 3) return;

    _searchDebounce = Timer(debounce, () async {
      final id = ++_searchRequestId;
      final results = await searchAddresses(query.trim(), requestId: id);
      if (id == _searchRequestId) onResults(results);
    });
  }

  void cancelSearchDebounce() => _searchDebounce?.cancel();

  final Dio _dio = Dio();
  // Using a simple session token implementation, we can just use a UUID or timestamp based string for the session.
  String? _sessionToken;

  Future<List<MapSearchResult>> searchAddresses(
    String query, {
    int? requestId,
  }) async {
    final key = query.toLowerCase().trim();

    if (_searchCache.containsKey(key)) {
      if (requestId != null && requestId != _searchRequestId) return [];
      return _searchCache[key]!;
    }

    final id = requestId ?? ++_searchRequestId;

    try {
      _sessionToken ??= DateTime.now().millisecondsSinceEpoch.toString();

      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': AppConfig.instance.googleMapsKey,
          'sessiontoken': _sessionToken,
          'components': 'country:bd', // Restricted to Bangladesh for better local results
        },
      );

      if (id != _searchRequestId) return [];

      final data = response.data;
      if (data['status'] != 'OK' && data['status'] != 'ZERO_RESULTS') {
        debugPrint('[MapLocationService] search error: ${data['status']}');
        return [];
      }

      final predictions = data['predictions'] as List? ?? [];
      final results = <MapSearchResult>[];

      for (final p in predictions.take(_maxSearchResults)) {
        final structuredFormatting = p['structured_formatting'];
        final mainText = structuredFormatting?['main_text'] as String? ?? '';
        final secondaryText = structuredFormatting?['secondary_text'] as String? ?? '';
        final placeId = p['place_id'] as String?;

        if (placeId == null) continue;

        results.add(MapSearchResult(
          query: query,
          formattedAddress: mainText,
          area: secondaryText,
          placeId: placeId,
        ));
      }

      if (id == _searchRequestId && results.isNotEmpty) {
        _searchCache[key] = results;
      }

      return id == _searchRequestId ? results : [];
    } catch (e) {
      debugPrint('[MapLocationService] searchAddresses error: $e');
      return [];
    }
  }

  Future<LatLng?> getPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'key': AppConfig.instance.googleMapsKey,
          'fields': 'geometry',
          'sessiontoken': _sessionToken,
        },
      );

      // Reset session token after a successful detail call
      _sessionToken = null;

      final data = response.data;
      if (data['status'] == 'OK') {
        final location = data['result']['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
    } catch (e) {
      debugPrint('[MapLocationService] getPlaceDetails error: $e');
    }
    return null;
  }

  // ─── Reverse geocode ─────────────────────────────────────────

  void scheduleReverseGeocode({
    required LatLng position,
    required void Function(MapAddressSnapshot snapshot) onResolved,
    required VoidCallback onUnknown,
    Duration debounce = const Duration(milliseconds: 350),
  }) {
    _reverseGeocodeDebounce?.cancel();
    _reverseGeocodeDebounce = Timer(debounce, () async {
      final snapshot = await reverseGeocode(position);
      if (snapshot != null) {
        onResolved(snapshot);
      } else {
        onUnknown();
      }
    });
  }

  void cancelReverseGeocodeDebounce() => _reverseGeocodeDebounce?.cancel();

  /// Resolves [position] to a [MapAddressSnapshot].
  ///
  /// Returns null if:
  /// - a geocode is already in progress, or
  /// - the position hasn't moved more than 25 m (unless [ignoreDistanceCheck]).
  Future<MapAddressSnapshot?> reverseGeocode(
      LatLng position, {
        bool ignoreDistanceCheck = false,
      }) async {
    if (_isGeocoding) return null;

    if (!ignoreDistanceCheck && _lastGeocodedPosition != null) {
      final distance = Geolocator.distanceBetween(
        _lastGeocodedPosition!.latitude,
        _lastGeocodedPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      if (distance < 25) return null;
    }

    _isGeocoding = true;
    _lastGeocodedPosition = position;
    final id = ++_geocodeRequestId;

    try {
      final placemarks = await _geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (id != _geocodeRequestId || placemarks.isEmpty) return null;

      final place = placemarks.first;
      return MapAddressSnapshot(
        address: place.formattedAddress,
        area: place.formattedArea,
        position: position,
      );
    } catch (e) {
      debugPrint('[MapLocationService] reverseGeocode error: $e');
      return null;
    } finally {
      _isGeocoding = false;
    }
  }

  // ─── Camera ──────────────────────────────────────────────────

  Future<void> moveCamera({
    required GoogleMapController? controller,
    required LatLng target,
    double zoom = MapLocationDefaults.pickerZoom,
  }) {
    return controller?.animateCamera(
      CameraUpdate.newLatLngZoom(target, zoom),
    ) ??
        Future.value();
  }

  Future<void> applySearchResult({
    required MapSearchResult result,
    required GoogleMapController? mapController,
    required void Function(MapAddressSnapshot snapshot) onApplied,
    double zoom = MapLocationDefaults.pickerZoom,
  }) async {
    LatLng? targetPosition = result.position;

    if (targetPosition == null && result.placeId != null) {
      final details = await getPlaceDetails(result.placeId!);
      if (details != null) {
        targetPosition = details;
      }
    }

    if (targetPosition == null) {
      // If we still don't have a location, we can't apply it.
      return; 
    }

    _lastGeocodedPosition = targetPosition;
    await moveCamera(
      controller: mapController,
      target: targetPosition,
      zoom: zoom,
    );
    onApplied(
      MapAddressSnapshot(
        address: result.formattedAddress,
        area: result.area,
        position: targetPosition,
      ),
    );
  }
}