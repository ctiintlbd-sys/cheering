import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../features/address/domain/entities/map_location_entities.dart';
import '../utils/placemark_extension.dart';
import 'places_api_client.dart';

/// Turns map coordinates into addresses and search queries into places.
///
/// Holds per-picker mutable state (debounce timers, last resolved position), so
/// every map picker needs its own instance and must [dispose] of it.
class MapLocationService {
  MapLocationService({Geocoding? geocoding, PlacesApiClient? placesClient})
    : _geocodingInstance = geocoding,
      _placesInstance = placesClient;

  /// Below this distance a camera idle is treated as the same spot, so we skip
  /// the lookup instead of spending a geocode on it.
  static const double _minGeocodeDistanceMeters = 25;

  // Built on first use so a picker that never geocodes or searches pays for
  // neither, and so subclasses can stand in without touching the plugins.
  Geocoding? _geocodingInstance;
  PlacesApiClient? _placesInstance;

  Geocoding get _geocoding => _geocodingInstance ??= Geocoding();
  PlacesApiClient get _places => _placesInstance ??= PlacesApiClient();

  Timer? _searchDebounce;
  Timer? _reverseGeocodeDebounce;

  int _searchRequestId = 0;
  int _geocodeRequestId = 0;

  LatLng? _lastGeocodedPosition;
  bool _isGeocoding = false;

  // ─── Lifecycle ───────────────────────────────────────────────

  void cancelPendingWork() {
    _searchDebounce?.cancel();
    _reverseGeocodeDebounce?.cancel();
    _searchRequestId++;
    _geocodeRequestId++;
  }

  void dispose() {
    cancelPendingWork();
    // Only if a search actually created one; don't build a client to close it.
    _placesInstance?.close();
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

  Future<List<MapSearchResult>> searchAddresses(
    String query, {
    int? requestId,
  }) async {
    final id = requestId ?? ++_searchRequestId;
    final results = await _places.autocomplete(query);
    return id == _searchRequestId ? results : const [];
  }

  /// Resolves the coordinates of a search result, fetching place details only
  /// when the result didn't already carry a position.
  Future<LatLng?> resolveSearchResultPosition(MapSearchResult result) async {
    if (result.position != null) return result.position;
    if (result.placeId == null) return null;
    return _places.placeLocation(result.placeId!);
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
      switch (await reverseGeocode(position)) {
        case ReverseGeocodeResolved(:final snapshot):
          onResolved(snapshot);
        case ReverseGeocodeFailed():
          onUnknown();
        case ReverseGeocodeSkipped():
          break;
      }
    });
  }

  void cancelReverseGeocodeDebounce() => _reverseGeocodeDebounce?.cancel();

  /// Resolves [position] to an address.
  ///
  /// Skips the lookup when one is already running or the pin moved less than
  /// [_minGeocodeDistanceMeters] (unless [ignoreDistanceCheck]).
  Future<ReverseGeocodeOutcome> reverseGeocode(
    LatLng position, {
    bool ignoreDistanceCheck = false,
  }) async {
    if (_isGeocoding) return const ReverseGeocodeSkipped();

    if (!ignoreDistanceCheck && _lastGeocodedPosition != null) {
      final distance = Geolocator.distanceBetween(
        _lastGeocodedPosition!.latitude,
        _lastGeocodedPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      if (distance < _minGeocodeDistanceMeters) {
        return const ReverseGeocodeSkipped();
      }
    }

    _isGeocoding = true;
    _lastGeocodedPosition = position;
    final id = ++_geocodeRequestId;

    try {
      final placemarks = await _geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (id != _geocodeRequestId) return const ReverseGeocodeSkipped();
      if (placemarks.isEmpty) {
        debugPrint('[MapLocationService] no placemark for $position');
        return const ReverseGeocodeFailed();
      }

      final place = placemarks.first;
      return ReverseGeocodeResolved(
        MapAddressSnapshot(
          address: place.formattedAddress,
          area: place.formattedArea,
          position: position,
        ),
      );
    } catch (e) {
      debugPrint('[MapLocationService] reverseGeocode error: $e');
      return const ReverseGeocodeFailed();
    } finally {
      _isGeocoding = false;
    }
  }

  /// Records [position] as already resolved so the next camera idle nearby
  /// doesn't spend a geocode re-resolving it.
  void markPositionResolved(LatLng position) {
    _lastGeocodedPosition = position;
  }
}
