import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/feature/user_settings/domain/entity/user_settings.dart';
import 'package:todo_app/feature/user_settings/domain/repository/user_settings_repository.dart';

import '../model/user_settings_model.dart';

@Injectable(as: UserSettingsRepository)
class UserSettingsRepositoryImpl implements UserSettingsRepository {
  final Box<UserSettingsModel> _box;

  UserSettingsRepositoryImpl({required Box<UserSettingsModel> box})
      : _box = box;

  @override
  Future<UserSettings> get() {
    if (_box.values.isEmpty) {
      return Future.value(const UserSettings(locale: Locale('en')));
    }
    final userSettingsModel = _box.values.first;
    return Future.value(
      UserSettings(
        locale: Locale(userSettingsModel.locale),
      ),
    );
  }

  @override
  Future<void> save(UserSettings userSettings) {
    final userSettingsModel =
        UserSettingsModel(locale: userSettings.locale.languageCode);
    return _box.put(0, userSettingsModel);
  }
}
