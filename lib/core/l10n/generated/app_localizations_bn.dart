// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'চিয়ারিং পার্টনার';

  @override
  String get loginTitle => 'স্বাগতম';

  @override
  String get loginSubtitle => 'এগিয়ে যেতে লগইন করুন';

  @override
  String get loginButton => 'লগইন করুন';

  @override
  String get registerTitle => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get registerButton => 'সাইন আপ';

  @override
  String get logoutButton => 'লগ আউট';

  @override
  String get otpTitle => 'নম্বর যাচাই করুন';

  @override
  String otpSubtitle(String phone) {
    return '$phone নম্বরে পাঠানো ৬-ডিজিটের কোডটি লিখুন';
  }

  @override
  String get emailLabel => 'ইমেইল';

  @override
  String get passwordLabel => 'পাসওয়ার্ড';

  @override
  String get phoneLabel => 'ফোন নম্বর';

  @override
  String get nameLabel => 'পুরো নাম';

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
  String get errorUnauthorized => 'সেশন শেষ হয়ে গেছে। আবার লগইন করুন।';

  @override
  String get retryButton => 'আবার চেষ্টা করুন';

  @override
  String get loadingText => 'লোড হচ্ছে...';

  @override
  String get getStartedButton => 'শুরু করুন';

  @override
  String get splashTitle => 'চিয়ারিং';

  @override
  String get splashSubtitle => 'সবকিছু অর্ডার করুন';

  @override
  String get onboardingTitle1 => 'খাবার অর্ডার ও রাইড বুকিং';

  @override
  String get onboardingSubtitle1 =>
      'খুব সহজেই ফাস্ট ফুড ডেলিভারি, ইনস্ট্যান্ট রাইড বুকিং এবং বিশ্বস্ত দৈনন্দিন সেবা উপভোগ করুন।';

  @override
  String get onboardingTitle2 => 'মুহূর্তেই পে ও টপ আপ করুন';

  @override
  String get onboardingSubtitle2 =>
      'সহজে ও নিরাপদে ওয়ালেটে টাকা যোগ করুন, পেমেন্ট করুন এবং যেকোনো সময় আপনার ওয়ালেট ম্যানেজ করুন।';

  @override
  String get onboardingTitle3 => 'প্রতিদিন শপিং করুন ও সেভ করুন';

  @override
  String get onboardingSubtitle3 =>
      'গ্রোসারি কিনুন, ওষুধ অর্ডার করুন, দারুণ সব ডিলস এক্সপ্লোর করুন এবং আপনার প্রয়োজনীয় সবকিছু এক অ্যাপেই পান।';
}
