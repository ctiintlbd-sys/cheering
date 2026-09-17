import '../../domain/entities/address_entity.dart';

extension AddressEntityDisplay on AddressEntity {
  String get titleLabel {
    return switch (type) {
      AddressType.home => 'Home',
      AddressType.work => 'Work',
      AddressType.other =>
        (label != null && label!.trim().isNotEmpty) ? label!.trim() : 'Other',
      AddressType.unknown => label?.trim().isNotEmpty == true ? label! : 'Address',
    };
  }

  String get subtitleLine1 {
    final parts = <String>[
      if (streetAddress != null && streetAddress!.trim().isNotEmpty)
        streetAddress!.trim(),
      if (apartment != null && apartment!.trim().isNotEmpty) apartment!.trim(),
    ];
    return parts.join(', ');
  }

  String get subtitleLine2 {
    return [
      if (city != null && city!.trim().isNotEmpty) city!.trim(),
      if (postalCode != null && postalCode!.trim().isNotEmpty)
        postalCode!.trim(),
    ].join(', ');
  }

  bool matchesSearch(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return [
      titleLabel,
      streetAddress,
      apartment,
      landmark,
      city,
      postalCode,
      contactPhone,
    ].any((v) => v != null && v.toLowerCase().contains(q));
  }
}
