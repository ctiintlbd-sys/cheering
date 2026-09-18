import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
class MapSearchResult {
  const MapSearchResult({
    required this.query,
    required this.formattedAddress,
    required this.area,
    this.position,
    this.placeId,
  });

  final String query;
  final String formattedAddress;
  final String area;
  final LatLng? position;
  final String? placeId;
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
