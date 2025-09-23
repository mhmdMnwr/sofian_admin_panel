part of 'locale_cubit.dart';

abstract class LocaleState {}

class LocaleInitial extends LocaleState {}

class LocaleChanged extends LocaleState {
  final Locale locale;

  LocaleChanged(this.locale);
}

class LocaleError extends LocaleState {
  final String message;

  LocaleError(this.message);
}
