import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';
import 'package:sofian_admin_panel/core/theming/cubit/theme_cubit.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';
import 'package:sofian_admin_panel/l10n/cubit/locale_cubit.dart';

class SettingsRow extends StatelessWidget {
  const SettingsRow({super.key});

  @override
  Widget build(BuildContext context) {
    changeThemeIcon() {
      final isDark = context.read<ThemeCubit>().state.isDark;
      if (isDark) {
        return IconsManager.lightMode;
      }
      return IconsManager.darkMode;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _iconButton(changeThemeIcon(), () {
            context.read<ThemeCubit>().toggleTheme();
          }, context),
          horizontalSpace(10),
          _iconButton(IconsManager.changeLanguage, () {
            _showLanguageDialog(context);
          }, context),
          horizontalSpace(10),
          _iconButton(IconsManager.settings, () {}, context),
        ],
      ),
    );
  }

  Widget _iconButton(
    String iconPath,
    VoidCallback onPressed,
    BuildContext context,
  ) {
    return IconButton(
      icon: Image.asset(
        iconPath,
        width: 35,
        height: 35,
        color: Theme.of(context).iconTheme.color,
      ),

      onPressed: onPressed,
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, state) {
            final currentLocale = context.read<LocaleCubit>().currentLocale;

            return Directionality(
              textDirection: context.read<LocaleCubit>().textDirection,
              child: AlertDialog(
                title: Text(AppLocalizations.of(context)!.select_language),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: LocaleCubit.supportedLocales.map((locale) {
                    final isSelected =
                        currentLocale.languageCode == locale.languageCode;
                    final displayName = context
                        .read<LocaleCubit>()
                        .getLocaleDisplayName(locale);

                    return ListTile(
                      title: Text(
                        displayName,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 16),
                        textAlign: locale.languageCode == 'ar'
                            ? TextAlign.right
                            : TextAlign.left,
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).iconTheme.color,
                            )
                          : null,
                      onTap: () {
                        _changeLanguage(context, locale);
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) {
    context.read<LocaleCubit>().changeLanguage(locale);
  }
}
