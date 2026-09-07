// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Cheering Partner';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get loginButton => 'Sign In';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerButton => 'Sign Up';

  @override
  String get logoutButton => 'Log Out';

  @override
  String get otpTitle => 'Verify your number';

  @override
  String otpSubtitle(String phone) {
    return 'Enter the 6-digit code sent to $phone';
  }

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get nameLabel => 'Full name';

  @override
  String get homeTitle => 'Home';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorUnauthorized => 'Session expired. Please login again.';

  @override
  String get retryButton => 'Retry';

  @override
  String get loadingText => 'Loading...';

  @override
  String get getStartedButton => 'Get Started';

  @override
  String get splashTitle => 'CHEERING';

  @override
  String get splashSubtitle => 'Order everything';

  @override
  String get onboardingTitle1 => 'Order Food & Book Rides';

  @override
  String get onboardingSubtitle1 =>
      'Enjoy fast food delivery, instant ride booking, and trusted everyday services with just a few simple taps.';

  @override
  String get onboardingTitle2 => 'Pay & Top Up Instantly';

  @override
  String get onboardingSubtitle2 =>
      'Add money, make secure payments, and manage your wallet anytime with a smooth and simple experience.';

  @override
  String get onboardingTitle3 => 'Shop & Save Every Day';

  @override
  String get onboardingSubtitle3 =>
      'Buy groceries, order medicines, explore great deals, and enjoy everything you need in one convenient app.';
}
