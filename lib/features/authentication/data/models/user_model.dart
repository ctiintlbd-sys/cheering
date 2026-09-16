import '../../domain/entities/user_entity.dart';

/// JSON DTO for user objects in login responses and profile APIs.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.role,
    required super.email,
    super.phone,
    required super.fullName,
    super.avatarUrl,
    required super.isEmailVerified,
    required super.isPhoneVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name.toUpperCase() == json['role']?.toString().toUpperCase(),
        orElse: () => UserRole.unknown,
      ),
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      fullName: json['full_name']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      isEmailVerified: json['is_email_verified'] == true,
      isPhoneVerified: json['is_phone_verified'] == true,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      role: entity.role,
      email: entity.email,
      phone: entity.phone,
      fullName: entity.fullName,
      avatarUrl: entity.avatarUrl,
      isEmailVerified: entity.isEmailVerified,
      isPhoneVerified: entity.isPhoneVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.name.toUpperCase(),
      'email': email,
      'phone': phone,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
    };
  }
}
