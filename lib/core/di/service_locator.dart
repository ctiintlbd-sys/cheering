import 'package:get_it/get_it.dart';
import 'address_dependencies.dart';
import 'core_dependencies.dart';
import 'auth_dependencies.dart';
import 'profile_dependencies.dart';

/// Global GetIt instance alias
final GetIt getIt = GetIt.instance;

/// Initialize all dependencies using GetIt
Future<void> setupServiceLocator() async {
  setupCoreDependencies(getIt);
  setupProfileDependencies(getIt);
  setupAddressDependencies(getIt);
  setupAuthDependencies(getIt);
}
