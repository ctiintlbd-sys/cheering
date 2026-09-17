import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
class MapSearchResult {
  const MapSearchResult({
    required this.query,
    required this.formattedAddress,
    required this.area,
    required this.position,
  });

  final String query;
  final String formattedAddress;
  final String area;
  final LatLng position;
}

@immutable
class MapAddressSnapshot {
  const MapAddressSnapshot({
    required this.address,
    required this.area,
    required this.position,
  });

  final String address;
  final String area;
  final LatLng position;
}

abstract final class MapLocationDefaults {
  static const LatLng dhaka = LatLng(23.7937, 90.4066);
  static const double pickerZoom = 16;
  static const String locatingLabel = 'Locating...';
  static const String unknownLabel = 'Unknown Location';
  static const String selectedFallbackLabel = 'Selected Location';

  static bool isConfirmableAddress(String address) {
    final v = address.trim();
    return v.isNotEmpty &&
        v != locatingLabel &&
        v != unknownLabel &&
        v != selectedFallbackLabel;
  }
}

class MapLocationService {
  MapLocationService({Geocoding? geocoding})
    : _geocoding = geocoding ?? Geocoding();

  final Geocoding _geocoding;

  // Search cache — lives for the app session
  static final Map<String, MapSearchResult> _searchCache = {};

  Timer? _searchDebounce;
  Timer? _reverseGeocodeDebounce;

  // Request IDs to cancel stale async results
  int _searchRequestId = 0;
  int _geocodeRequestId = 0;

  // Tracks last geocoded position to skip redundant reverse geocode calls
  LatLng? _lastGeocodedPosition;
  bool _isGeocoding = false;

  bool get isGeocoding => _isGeocoding;

  // ─── Lifecycle ───────────────────────────────────────────────

  /// Call this only when the service itself should be torn down.
  /// Do NOT call from a screen if registered as a singleton in DI.
  void cancelPendingWork() {
    _searchDebounce?.cancel();
    _reverseGeocodeDebounce?.cancel();
    _searchRequestId++;
    _geocodeRequestId++;
  }

  // ─── Placemark helpers ───────────────────────────────────────

  String areaFromPlacemark(Placemark place) {
    final admin = place.administrativeArea?.trim() ?? '';
    final postal = place.postalCode?.trim() ?? '';
    if (admin.isNotEmpty && postal.isNotEmpty) return '$admin, $postal';
    if (admin.isNotEmpty) return admin;
    if (postal.isNotEmpty) return postal;
    return '';
  }

  String addressFromPlacemark(Placemark place) {
    final parts = [
      place.street,
      place.subLocality,
      place.locality,
    ].where((p) => p != null && p.isNotEmpty).join(', ');

    if (parts.isNotEmpty) return parts;
    final name = place.name?.trim() ?? '';
    return name.isNotEmpty ? name : MapLocationDefaults.selectedFallbackLabel;
  }

  // ─── Forward geocode (search) ────────────────────────────────

  /// Debounced address search. Ignores queries shorter than 3 chars.
  void scheduleAddressSearch({
    required String query,
    required void Function(MapSearchResult result) onResult,
    Duration debounce = const Duration(milliseconds: 500),
  }) {
    _searchDebounce?.cancel();
    if (query.trim().length < 3) return;

    _searchDebounce = Timer(debounce, () async {
      final result = await searchAddress(query.trim());
      if (result != null) onResult(result);
    });
  }

  void cancelSearchDebounce() => _searchDebounce?.cancel();

  Future<MapSearchResult?> searchAddress(String query) async {
    final key = query.toLowerCase();
    if (_searchCache.containsKey(key)) return _searchCache[key];

    final id = ++_searchRequestId;

    try {
      final locations = await _geocoding.locationFromAddress(query);
      if (id != _searchRequestId || locations.isEmpty) return null;

      final loc = locations.first;
      final latLng = LatLng(loc.latitude, loc.longitude);

      var address = query;
      var area = '';

      try {
        final placemarks = await _geocoding.placemarkFromCoordinates(
          loc.latitude,
          loc.longitude,
        );
        if (id != _searchRequestId) return null;

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final resolved = addressFromPlacemark(place);
          address = resolved == MapLocationDefaults.selectedFallbackLabel
              ? query
              : resolved;
          area = areaFromPlacemark(place);
        }
      } catch (_) {
        // keep address = query if reverse lookup fails
      }

      final result = MapSearchResult(
        query: query,
        formattedAddress: address,
        area: area,
        position: latLng,
      );
      if (id == _searchRequestId) _searchCache[key] = result;
      return id == _searchRequestId ? result : null;
    } catch (e) {
      debugPrint('[MapLocationService] searchAddress error: $e');
      return null;
    }
  }

  // ─── Reverse geocode ─────────────────────────────────────────

  /// Debounced reverse geocode on camera idle.
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

  /// Returns null if already geocoding, or position hasn't moved > 25 m.
  /// Pass [ignoreDistanceCheck] = true to force a fresh lookup (e.g. GPS jump).
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
        address: addressFromPlacemark(place),
        area: areaFromPlacemark(place),
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

  /// Moves camera to search result and fires [onApplied] with the snapshot.
  Future<void> applySearchResult({
    required MapSearchResult result,
    required GoogleMapController? mapController,
    required void Function(MapAddressSnapshot snapshot) onApplied,
    double zoom = MapLocationDefaults.pickerZoom,
  }) async {
    _lastGeocodedPosition = result.position;
    await moveCamera(
      controller: mapController,
      target: result.position,
      zoom: zoom,
    );
    onApplied(
      MapAddressSnapshot(
        address: result.formattedAddress,
        area: result.area,
        position: result.position,
      ),
    );
  }
}
