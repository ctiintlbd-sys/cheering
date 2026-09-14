enum UserRole { customer, vendor, admin, unknown }

class UserEntity {
  final String id;
  final UserRole role;
  final String email;
  final String? phone;
  final String fullName;
  final String? avatarUrl;
  final bool isEmailVerified;
  final bool isPhoneVerified;

  const UserEntity({
    required this.id,
    required this.role,
    required this.email,
    this.phone,
    required this.fullName,
    this.avatarUrl,
    required this.isEmailVerified,
    required this.isPhoneVerified,
  });

  UserEntity copyWith({
    String? id,
    UserRole? role,
    String? email,
    String? phone,
    String? fullName,
    String? avatarUrl,
    bool? isEmailVerified,
    bool? isPhoneVerified,
  }) {
    return UserEntity(
      id: id ?? this.id,
      role: role ?? this.role,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
    );
  }
}
