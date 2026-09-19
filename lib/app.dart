import 'package:cheering/core/session/profile_session_sync.dart';
import 'package:cheering/core/theme/theme_cubit.dart';
import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/router/app_router.dart';
import 'package:cheering/features/address/presentation/bloc/address_event.dart';
import 'package:cheering/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:cheering/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cheering/features/address/presentation/bloc/address_bloc.dart';
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
        BlocProvider(create: (_) => getIt<LocaleCubit>()),
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<ProfileBloc>()),
        BlocProvider(create: (_) => getIt<AddressBloc>()..add(LoadAddressesRequested())),
      ],
      child: ProfileSessionSync(
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) => MaterialApp.router(
              scaffoldMessengerKey: ToastMessageHelper.messengerKey,
              debugShowCheckedModeBanner: false,
              title: 'Cheering',
              locale: locale,
              themeMode: ThemeMode.light,
              theme: AppTheme.light(),
              routerConfig: AppRouter.router,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, child) => child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
