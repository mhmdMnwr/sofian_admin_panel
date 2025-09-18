// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get welcome => 'Welcome Back';

  @override
  String get login => 'Login';

  @override
  String get username => 'username';

  @override
  String get password => 'password';

  @override
  String get enter_username => 'Please enter your username';

  @override
  String get enter_password => 'Please enter your password';
}
