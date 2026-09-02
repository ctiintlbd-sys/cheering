// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'চিয়ারিং ভেন্ডর';

  @override
  String get loginTitle => 'স্বাগতম';

  @override
  String get loginSubtitle => 'চালিয়ে যেতে সাইন ইন করুন';

  @override
  String get loginButton => 'সাইন ইন';

  @override
  String get registerTitle => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get registerButton => 'নিবন্ধন করুন';

  @override
  String get logoutButton => 'লগ আউট';

  @override
  String get otpTitle => 'নম্বর যাচাই করুন';

  @override
  String otpSubtitle(String phone) {
    return '$phone নম্বরে পাঠানো ৬ সংখ্যার কোড দিন';
  }

  @override
  String get emailLabel => 'ইমেইল';

  @override
  String get passwordLabel => 'পাসওয়ার্ড';

  @override
  String get phoneLabel => 'ফোন নম্বর';

  @override
  String get nameLabel => 'পূর্ণ নাম';

  @override
  String get homeTitle => 'হোম';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get languageLabel => 'ভাষা';

  @override
  String get themeLabel => 'থিম';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get themeLight => 'লাইট';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get errorGeneric => 'কিছু একটা ভুল হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get errorNetwork => 'ইন্টারনেট সংযোগ নেই।';

  @override
  String get errorUnauthorized => 'সেশন শেষ হয়ে গেছে। আবার লগ ইন করুন।';

  @override
  String get retryButton => 'আবার চেষ্টা করুন';

  @override
  String get loadingText => 'লোড হচ্ছে...';
}
