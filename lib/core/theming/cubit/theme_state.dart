import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  final bool isDark;

  const ThemeState({required this.isDark});

  factory ThemeState.light() => const ThemeState(isDark: false);
  factory ThemeState.dark() => const ThemeState(isDark: true);

  @override
  List<Object> get props => [isDark];
}
