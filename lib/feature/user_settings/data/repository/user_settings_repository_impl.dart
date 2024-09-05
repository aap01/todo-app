import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/feature/user_settings/domain/entity/user_settings.dart';
import 'package:todo_app/feature/user_settings/domain/repository/user_settings_repository.dart';

import '../datasource/user_settings_local_datasource.dart';
import '../datasource/user_settings_remote_datasource.dart';
import '../mapper/user_settings_mapper.dart';
import '../model/user_settings_firestore_model.dart';
import '../model/user_settings_hive_model.dart';

@Injectable(as: UserSettingsRepository)
class UserSettingsRepositoryImpl implements UserSettingsRepository {
  final UserSettingsLocalDataSource _localDataSource;
  final UserSettingsRemoteDataSource _remoteDataSource;

  UserSettingsRepositoryImpl({
    required UserSettingsLocalDataSource localDataSource,
    required UserSettingsRemoteDataSource remoteDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<UserSettings> get() async {
    final userSettings = await _localDataSource.get();
    if (userSettings == null) {
      final defaultUserSettings = UserSettings.defaultSettings();
      await _localDataSource
          .save(UserSettingsMapper.toHiveModel(defaultUserSettings));
      return defaultUserSettings;
    }
    return UserSettingsMapper.fromHiveModel(userSettings);
  }

  @override
  Future<void> save({Locale? locale}) async {
    if (locale == null) return;
    final userSettings = await get();
    if (userSettings.locale == locale) return;
    await _localDataSource.save(
        UserSettingsMapper.toHiveModel(userSettings.updateLocale(locale)));
  }

  @override
  Future<void> sync() async {
    debugPrint('Syncing user settings');
    Future<UserSettingsHiveModel?> localSettingsFuture = _localDataSource.get();
    Future<UserSettingsFirestoreModel?> remoteSettingsFuture =
        _remoteDataSource.get();
    final (localSettings, remoteSettings) = await (
      localSettingsFuture,
      remoteSettingsFuture,
    ).wait;

    if (remoteSettings == null && localSettings == null) {
      return;
    } else if (localSettings == null && remoteSettings != null) {
      await _localDataSource.save(UserSettingsMapper.toHiveModel(
          UserSettingsMapper.fromFirestoreModel(remoteSettings)));
    } else if (remoteSettings == null && localSettings != null) {
      await _remoteDataSource.save(UserSettingsMapper.toFirestoreModel(
          UserSettingsMapper.fromHiveModel(localSettings)));
    } else if (remoteSettings != null && localSettings != null) {
      final remoteUpdatedAt = remoteSettings.updatedAt;
      final localUpdatedAt = localSettings.updatedAt;
      if (remoteUpdatedAt.isAfter(localUpdatedAt)) {
        await _localDataSource.save(UserSettingsMapper.toHiveModel(
            UserSettingsMapper.fromFirestoreModel(remoteSettings)));
      } else {
        await _remoteDataSource.update(UserSettingsMapper.toFirestoreModel(
            UserSettingsMapper.fromHiveModel(localSettings)));
      }
    }
  }
}
