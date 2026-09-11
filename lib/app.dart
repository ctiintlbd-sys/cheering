import 'package:cheering/core/theme/theme_cubit.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/router/app_router.dart';
import 'package:cheering/features/overview/presentation/bloc/overview_bloc.dart';
import 'package:cheering/features/overview/presentation/bloc/overview_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/service_locator.dart';
import 'core/l10n/l10n.dart';
import 'core/theme/app_theme.dart';
import 'package:cheering/core/l10n/locale_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<LocaleCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<ThemeCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<OverviewBloc>()..add(const LoadOverview()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) => BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                scaffoldMessengerKey: ToastMessageHelper.messengerKey,
                debugShowCheckedModeBanner: false,
                title: 'Cheering',
                locale: locale,
                themeMode: ThemeMode.light,
                theme: AppTheme.light(),
                //darkTheme: AppTheme.dark(),
                routerConfig: AppRouter.router,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
