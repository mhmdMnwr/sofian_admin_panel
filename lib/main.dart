import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/routing/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sofian_admin_panel/core/theming/app_theme.dart';
import 'package:sofian_admin_panel/core/theming/cubit/theme_cubit.dart';
import 'package:sofian_admin_panel/core/theming/cubit/theme_state.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';
import 'package:sofian_admin_panel/l10n/cubit/locale_cubit.dart';

void main() {
  runApp(AdminPanel());
}

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => LocaleCubit()),
      ],
      child: ScreenUtilInit(
        designSize: Size(1512, 982),
        minTextAdapt: true,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, localeState) {
                final localeCubit = context.read<LocaleCubit>();

                return MaterialApp.router(
                  routerConfig: appRouter,
                  title: 'Admin Panel',
                  theme: ThemeManager.lightTheme,
                  darkTheme: ThemeManager.darkTheme,
                  themeMode: themeState.isDark
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  debugShowCheckedModeBanner: false,

                  // Locale and direction handling
                  locale: localeCubit.currentLocale,
                  supportedLocales: LocaleCubit.supportedLocales,

                  // Add RTL support
                  localeResolutionCallback: (locale, supportedLocales) {
                    // Check if the current locale is supported
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                              locale?.languageCode &&
                          supportedLocale.countryCode == locale?.countryCode) {
                        return supportedLocale;
                      }
                    }
                    // If not supported, find by language code only
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                          locale?.languageCode) {
                        return supportedLocale;
                      }
                    }
                    // Default to English
                    return const Locale('en', 'US');
                  },

                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],

                  // Custom builder to handle RTL direction
                  builder: (context, child) {
                    return Directionality(
                      textDirection: localeCubit.textDirection,
                      child: child ?? const SizedBox(),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
