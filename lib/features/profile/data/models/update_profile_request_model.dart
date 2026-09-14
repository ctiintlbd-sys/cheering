class UpdateProfileRequestModel {
  final String fullName;
  final String? avatarUrl;
  final String? phone;

  const UpdateProfileRequestModel({
    required this.fullName,
    this.avatarUrl,
    this.phone,
  });

  /// Serializes to a JSON map.
  ///
  /// According to the API specification: "PUT replaces the mutable profile entirely,
  /// so omitting a field clears it."
  /// When [avatarUrl] or [phone] is null or empty, it is omitted from the payload
  /// so that the server clears the field.
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      if (avatarUrl != null && avatarUrl!.trim().isNotEmpty)
        'avatar_url': avatarUrl!.trim(),
      if (phone != null && phone!.trim().isNotEmpty)
        'phone': phone!.trim(),
    };
  }
}
