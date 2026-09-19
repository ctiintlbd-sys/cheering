import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum CurrentLocationFailure {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  unavailable;

  String get message => switch (this) {
    serviceDisabled => 'Location services are disabled on your device.',
    permissionDenied => 'Location permissions are denied.',
    permissionDeniedForever => 'Location permissions are permanently denied.',
    unavailable => 'Unable to get your current location.',
  };
}

class CurrentLocationResult {
  const CurrentLocationResult._({this.latLng, this.failure});
  const CurrentLocationResult.success(LatLng latLng) : this._(latLng: latLng);
  const CurrentLocationResult.failure(CurrentLocationFailure failure)
    : this._(failure: failure);

  final LatLng? latLng;
  final CurrentLocationFailure? failure;

  bool get isSuccess => latLng != null;
}

class CurrentLocationService {
  // Session-level cache, shared by every caller
  static LatLng? _cachedLatLng;
  static DateTime? _cachedAt;

  /// Call on logout so the next session doesn't start from the previous
  /// user's position.
  static void clearCache() {
    _cachedLatLng = null;
    _cachedAt = null;
  }

  /// Pass [maxCacheAge] to accept a recent cached fix instead of waiting for a
  /// fresh one — a full GPS fix can take several seconds on a slow device.
  Future<CurrentLocationResult> fetchCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.best,
    bool requestPermission = true,
    Duration? maxCacheAge,
  }) async {
    final cached = _cachedWithin(maxCacheAge);
    if (cached != null) return CurrentLocationResult.success(cached);

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return _failure(CurrentLocationFailure.serviceDisabled);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && requestPermission) {
        permission = await Geolocator.requestPermission();
      }

      return switch (permission) {
        LocationPermission.denied => _failure(
          CurrentLocationFailure.permissionDenied,
        ),
        LocationPermission.deniedForever => _failure(
          CurrentLocationFailure.permissionDeniedForever,
        ),
        _ => await _fetchAndCache(accuracy),
      };
    } catch (e) {
      // Reaching here usually means a platform misconfiguration (e.g. the
      // location permissions missing from AndroidManifest.xml) rather than the
      // user refusing the prompt.
      debugPrint('[CurrentLocationService] threw before any fix: $e');
      return _failure(CurrentLocationFailure.unavailable);
    }
  }

  /// Every failure ends up showing the same placeholder row, so log which one
  /// it actually was.
  static CurrentLocationResult _failure(CurrentLocationFailure failure) {
    debugPrint('[CurrentLocationService] failed: ${failure.name}');
    return CurrentLocationResult.failure(failure);
  }

  static LatLng? _cachedWithin(Duration? maxAge) {
    if (maxAge == null) return null;
    final at = _cachedAt;
    if (at == null || _cachedLatLng == null) return null;
    return DateTime.now().difference(at) <= maxAge ? _cachedLatLng : null;
  }

  static CurrentLocationResult _cache(LatLng latLng) {
    _cachedLatLng = latLng;
    _cachedAt = DateTime.now();
    return CurrentLocationResult.success(latLng);
  }

  Future<CurrentLocationResult> _fetchAndCache(
    LocationAccuracy accuracy,
  ) async {
    try {
      // Prothome current position try korbe 8 second er timeout diye
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: const Duration(seconds: 8),
        ),
      );

      return _cache(LatLng(position.latitude, position.longitude));
    } catch (e) {
      // Current location pawa na gele ba time out hoye gele, device er last known location check korbe
      debugPrint(
        '[CurrentLocationService] no fresh fix ($e), trying last known',
      );
      try {
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          return _cache(LatLng(lastKnown.latitude, lastKnown.longitude));
        }
        // Common on a simulator with no simulated location set.
        debugPrint('[CurrentLocationService] no last known position either');
      } catch (e) {
        // Last known location o fail korle error dibe
        debugPrint('[CurrentLocationService] last known threw: $e');
      }

      return _failure(CurrentLocationFailure.unavailable);
    }
  }
}
