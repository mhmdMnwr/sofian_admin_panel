import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'), // English
    const Locale('ar'), // Arabic
    const Locale('fr'), // French
  ];

  static String getLanguageName(String code) {
    switch (code) {
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
}
