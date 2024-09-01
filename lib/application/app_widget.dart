import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/application/page/home_page.dart';

import '../di/dependency.dart';
import '../feature/user_settings/presentation/locale_bloc.dart';
import '../feature/user_settings/presentation/locale_state.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocaleBloc>()..loadLocale(),
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Todo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              textTheme:
                  GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: state.locale,
            home: const HomePage(
              title: 'Todo App',
            ),
          );
        },
      ),
    );
  }
}
