import 'package:get_it/get_it.dart';

import '../../features/earnings/presentation/cubit/earnings_cubit.dart';

void setupFeatureDependencies(GetIt getIt) {
  getIt.registerFactory<EarningsCubit>(() => EarningsCubit());
}
