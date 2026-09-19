import 'package:geocoding/geocoding.dart';
import '../../../features/address/domain/entities/map_location_entities.dart';

extension PlacemarkFormatting on Placemark {
  /// Extracts a clean, human-readable area label.
  String get formattedArea {
    final subLocality = _clean(this.subLocality);
    final locality = _clean(this.locality);
    final admin = _clean(administrativeArea);
    final postal = _clean(postalCode);

    final primary = subLocality.isNotEmpty
        ? subLocality
        : locality.isNotEmpty
        ? locality
        : admin;

    if (primary.isEmpty) return postal;

    if (postal.isNotEmpty && subLocality.isNotEmpty && locality.isEmpty) {
      return '$primary, $postal';
    }

    return primary;
  }

  /// Builds a clean address string, removing plus-codes and unnamed tokens.
  String get formattedAddress {
    final nameStr = _clean(name);
    final streetStr = _clean(street);
    final subLocalityStr = _clean(subLocality);
    final localityStr = _clean(locality);

    final parts = <String>[];

    if (_isUsablePart(nameStr)) parts.add(nameStr);

    if (_isUsablePart(streetStr) && streetStr != nameStr) {
      parts.add(streetStr);
    }

    if (_isUsablePart(subLocalityStr) && !parts.contains(subLocalityStr)) {
      parts.add(subLocalityStr);
    }

    if (_isUsablePart(localityStr) && !parts.contains(localityStr)) {
      parts.add(localityStr);
    }

    if (parts.isEmpty) {
      if (nameStr.isNotEmpty) return nameStr;
      return MapLocationDefaults.selectedFallbackLabel;
    }

    return parts.join(', ');
  }

  static String _clean(String? s) => s?.trim() ?? '';

  static bool _isUsablePart(String s) =>
      s.isNotEmpty && !s.contains('+') && !s.toLowerCase().contains('unnamed');
}
