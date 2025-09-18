import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.light());

  void toggleTheme() {
    emit(state.isDark ? ThemeState.light() : ThemeState.dark());
    print("the theme just changed from ${state.isDark ? "dark" : "light"} to ${state.isDark ? "light" : "dark"}");
  }
}
