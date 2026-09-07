import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../storage/locale_storage.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(LocaleStorage.getLocale());

  void updateLocale(Locale locale) {
    LocaleStorage.saveLocale(locale);
    emit(locale);
  }

  String get currentLanguageName {
    return state.languageCode == 'bn' ? 'Bangla' : 'English';
  }

  void updateLocaleFromName(String languageName) {
    final newLocale = languageName == 'Bangla' ? const Locale('bn') : const Locale('en');
    updateLocale(newLocale);
  }
}
