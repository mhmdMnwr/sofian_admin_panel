import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sofian_admin_panel/l10n/cubit/locale_cubit.dart';

class LocaleProvider extends StatelessWidget {
  final Widget child;

  const LocaleProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => LocaleCubit(), child: child);
  }
}

class LocaleConsumer extends StatelessWidget {
  final Widget Function(BuildContext context, Locale locale) builder;

  const LocaleConsumer({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocaleCubit, LocaleState>(
      listener: (context, state) {
        if (state is LocaleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final locale = context.read<LocaleCubit>().currentLocale;
        return builder(context, locale);
      },
    );
  }
}

// Extension to easily access LocaleCubit from BuildContext
extension LocaleExtension on BuildContext {
  LocaleCubit get localeCubit => read<LocaleCubit>();

  void changeLanguage(Locale locale) {
    read<LocaleCubit>().changeLanguage(locale);
  }

  Locale get currentLocale => read<LocaleCubit>().currentLocale;

  bool get isRTL => read<LocaleCubit>().isRTL;

  TextDirection get textDirection => read<LocaleCubit>().textDirection;
}
