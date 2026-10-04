import 'package:get_it/get_it.dart';
import 'address_dependencies.dart';
import 'core_dependencies.dart';
import 'auth_dependencies.dart';
import 'profile_dependencies.dart';
import 'food_dependencies.dart';
import 'cart_dependencies.dart';
import 'orders_dependencies.dart';
import 'tracking_dependencies.dart';
import 'search_dependencies.dart';
import 'chat_dependencies.dart';
import 'favorites_dependencies.dart';

/// Global GetIt instance alias
final GetIt getIt = GetIt.instance;

/// Initialize all dependencies using GetIt
Future<void> setupServiceLocator() async {
  setupCoreDependencies(getIt);
  setupProfileDependencies(getIt);
  setupAddressDependencies(getIt);
  setupAuthDependencies(getIt);
  setupFoodDependencies(getIt);
  setupFavoritesDependencies(getIt);
  setupCartDependencies(getIt);
  setupOrdersDependencies(getIt);
  setupTrackingDependencies(getIt);
  setupSearchDependencies(getIt);
  setupChatDependencies(getIt);
}
