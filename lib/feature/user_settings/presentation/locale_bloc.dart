import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/feature/user_settings/presentation/locale_state.dart';

import '../domain/usecase/get_user_settings.dart';
import '../domain/usecase/update_user_settings.dart';

@injectable
class LocaleBloc extends Cubit<LocaleState> {
  final GetUserSettings _getUserSettings;
  final UpdateUserSettings _updateUserSettings;

  LocaleBloc({
    required GetUserSettings getUserSettings,
    required UpdateUserSettings updateUserSettings,
  })  : _getUserSettings = getUserSettings,
        _updateUserSettings = updateUserSettings,
        super(const LocaleState(locale: Locale('en')));

  Future<void> loadLocale() async {
    final userSettings = await _getUserSettings();
    emit(LocaleState(locale: userSettings.locale));
  }

  Future<void> updateLocale(Locale locale) async {
    final userSettings = await _getUserSettings();
    await _updateUserSettings(userSettings.copyWith(locale: locale));
    emit(LocaleState(locale: locale));
  }
}
