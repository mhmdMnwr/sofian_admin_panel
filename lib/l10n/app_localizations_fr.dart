// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get hello => 'Bonjour';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get login => 'Connexion';

  @override
  String get username => 'nom d\'utilisateur';

  @override
  String get password => 'mot de passe';

  @override
  String get enter_username => 'Veuillez entrer votre nom d\'utilisateur';

  @override
  String get enter_password => 'Veuillez entrer votre mot de passe';
}
