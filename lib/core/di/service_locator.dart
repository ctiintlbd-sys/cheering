import 'package:get_it/get_it.dart';

import 'core_dependencies.dart';
import 'auth_dependencies.dart';
import 'overview_dependencies.dart';
import 'feature_dependencies.dart';
import 'business_hours_dependencies.dart';
import 'profile_dependencies.dart';

/// Global GetIt instance alias
final GetIt getIt = GetIt.instance;

/// Initialize all dependencies using GetIt
Future<void> setupServiceLocator() async {
  setupCoreDependencies(getIt);
  setupProfileDependencies(getIt);
  setupAuthDependencies(getIt);
  setupOverviewDependencies(getIt);
  setupFeatureDependencies(getIt);
  setupBusinessHoursDependencies(getIt);
}
