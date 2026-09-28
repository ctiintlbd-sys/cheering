import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/features/search/presentation/blocs/search/search_bloc.dart';
import 'package:cheering/features/search/presentation/blocs/search/search_event.dart';
import 'package:cheering/features/search/presentation/screens/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> searchRoutes = [
  GoRoute(
    path: RoutePaths.search,
    builder: (context, state) {
      return BlocProvider(
        create: (_) => getIt<SearchBloc>()..add(const LoadRecentSearches()),
        child: const SearchScreen(),
      );
    },
  ),
];
