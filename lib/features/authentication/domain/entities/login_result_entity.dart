import 'auth_tokens_entity.dart';
import 'user_entity.dart';

class LoginResultEntity {
  final AuthTokensEntity tokens;
  final UserEntity user;

  const LoginResultEntity({
    required this.tokens,
    required this.user,
  });
}
