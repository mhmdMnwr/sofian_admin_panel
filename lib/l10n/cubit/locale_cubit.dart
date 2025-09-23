import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  static const String _localeKey = 'selected_locale';

  LocaleCubit() : super(LocaleInitial()) {
    _loadSavedLocale();
  }

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('ar', 'SA'), // Arabic
    Locale('fr', 'FR'), // French
  ];

  // Load saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocaleCode = prefs.getString(_localeKey);

      if (savedLocaleCode != null) {
        final savedLocale = _getLocaleFromCode(savedLocaleCode);
        emit(LocaleChanged(savedLocale));
      } else {
        // Default to English if no saved locale
        emit(LocaleChanged(const Locale('en', 'US')));
      }
    } catch (e) {
      // Default to English on error
      emit(LocaleChanged(const Locale('en', 'US')));
    }
  }

  // Change language and save to SharedPreferences
  Future<void> changeLanguage(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _localeKey,
        '${locale.languageCode}_${locale.countryCode}',
      );
      emit(LocaleChanged(locale));
    } catch (e) {
      emit(LocaleError('Failed to save language preference'));
    }
  }

  // Get locale from saved code
  Locale _getLocaleFromCode(String code) {
    final parts = code.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }
    return const Locale('en', 'US'); // Default fallback
  }

  // Get current locale
  Locale get currentLocale {
    if (state is LocaleChanged) {
      return (state as LocaleChanged).locale;
    }
    return const Locale('en', 'US'); // Default
  }

  // Check if locale is RTL
  bool get isRTL {
    return currentLocale.languageCode == 'ar';
  }

  // Get text direction based on current locale
  TextDirection get textDirection {
    return isRTL ? TextDirection.rtl : TextDirection.ltr;
  }

  // Get locale display name
  String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }

  // Reset to default language
  Future<void> resetToDefault() async {
    await changeLanguage(const Locale('en', 'US'));
  }
}
