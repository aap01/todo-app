import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/feature/user_settings/presentation/locale_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LocaleToggleWidget extends StatelessWidget {
  final Locale locale;

  const LocaleToggleWidget({
    super.key,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      initialLabelIndex: locale == const Locale('en') ? 0 : 1,
      labels: const ['EN', 'عربى'],
      onToggle: (index) {
        if (index != null) {
          final bloc = context.read<LocaleBloc>();
          if (index == 0) {
            bloc.updateLocale(const Locale('en'));
          } else if (index == 1) {
            bloc.updateLocale(const Locale('ar'));
          }
        }
      },
    );
  }
}
