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
}
