import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/feature/user_settings/presentation/locale_state.dart';

import '../../../application/service/service_port_names.dart';
import '../domain/usecase/get_user_settings.dart';
import '../domain/usecase/update_user_settings.dart';

@injectable
class LocaleBloc extends Cubit<LocaleState> {
  final GetUserSettings _getUserSettings;
  final UpdateUserSettings _updateUserSettings;
  final ReceivePort _receivePort;

  @factoryMethod
  LocaleBloc({
    required GetUserSettings getUserSettings,
    required UpdateUserSettings updateUserSettings,
    @Named(ServicePortNames.userSettings) required ReceivePort receivePort,
  })  : _getUserSettings = getUserSettings,
        _updateUserSettings = updateUserSettings,
        _receivePort = receivePort,
        super(const LocaleState(locale: Locale('en')));

  void listenToBackgroundTask() {
    // TODO: separate into multiple classes UserSettingsWebBloc, UserSettingsMobileBloc
    if (kIsWeb) {
      return;
    } else {
      final isSuccess = IsolateNameServer.registerPortWithName(
          _receivePort.sendPort, ServicePortNames.userSettings);
      if (isSuccess) {
        debugPrint('ready to receive data from background for ${runtimeType}');
        _receivePort.listen((data) {
          if (data == true) loadLocale();
        });
      } else {
        IsolateNameServer.removePortNameMapping(ServicePortNames.userSettings)
            ? debugPrint('removed port')
            : debugPrint('port not removed');
        listenToBackgroundTask();
        debugPrint('failed to register port');
      }
    }
  }

  Future<void> loadLocale() async {
    final userSettings = await _getUserSettings();
    emit(LocaleState(locale: userSettings.locale));
  }

  Future<void> updateLocale(Locale locale) async {
    await _updateUserSettings(locale: locale);
    emit(LocaleState(locale: locale));
  }
}
