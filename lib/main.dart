import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/routing/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sofian_admin_panel/core/theming/app_theme.dart';
import 'package:sofian_admin_panel/core/theming/cubit/theme_cubit.dart';
import 'package:sofian_admin_panel/core/theming/cubit/theme_state.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

void main() {
  runApp(AdminPanel());
}

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: ScreenUtilInit(
        designSize: Size(1512, 982),
        minTextAdapt: true,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              routerConfig: appRouter,
              title: 'Admin Panel',
              theme: ThemeManager.lightTheme,

              darkTheme: ThemeManager.darkTheme,
              themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              supportedLocales: AppLocalizations.supportedLocales,

              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: Locale('en'),
            );
          },
        ),
      ),
    );
  }
}
