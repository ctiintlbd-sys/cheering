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
    permissionDeniedForever =>
    'Location permissions are permanently denied.',
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
  // Session-level cache — accessible statically from any screen
  static LatLng? _cachedLatLng;
  static LatLng? get latLng => _cachedLatLng;
  static bool get hasCachedLocation => _cachedLatLng != null;
  static void clearCache() => _cachedLatLng = null;

  Future<CurrentLocationResult> fetchCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
    bool requestPermission = true,
  }) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const CurrentLocationResult.failure(
          CurrentLocationFailure.serviceDisabled,
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && requestPermission) {
        permission = await Geolocator.requestPermission();
      }

      return switch (permission) {
        LocationPermission.denied => const CurrentLocationResult.failure(
          CurrentLocationFailure.permissionDenied,
        ),
        LocationPermission.deniedForever => const CurrentLocationResult.failure(
          CurrentLocationFailure.permissionDeniedForever,
        ),
        _ => await _fetchAndCache(accuracy),
      };
    } catch (_) {
      return const CurrentLocationResult.failure(
        CurrentLocationFailure.unavailable,
      );
    }
  }

  Future<CurrentLocationResult> _fetchAndCache(
      LocationAccuracy accuracy,
      ) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: accuracy),
      );
      final latLng = LatLng(position.latitude, position.longitude);
      _cachedLatLng = latLng;
      return CurrentLocationResult.success(latLng);
    } catch (_) {
      return const CurrentLocationResult.failure(
        CurrentLocationFailure.unavailable,
      );
    }
  }
}