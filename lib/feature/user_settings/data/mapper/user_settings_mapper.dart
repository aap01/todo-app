import 'package:flutter/material.dart';

import '../../domain/entity/user_settings.dart';
import '../model/user_settings_firestore_model.dart';
import '../model/user_settings_hive_model.dart';

abstract class UserSettingsMapper {
  static UserSettings fromHiveModel(UserSettingsHiveModel model) {
    return UserSettings(
      locale: Locale(model.locale),
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static UserSettings fromFirestoreModel(UserSettingsFirestoreModel model) {
    return UserSettings(
      locale: Locale(model.locale),
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static UserSettingsHiveModel toHiveModel(UserSettings settings) {
    return UserSettingsHiveModel(
      locale: settings.locale.languageCode,
      createdAt: settings.createdAt,
      updatedAt: settings.updatedAt,
    );
  }

  static UserSettingsFirestoreModel toFirestoreModel(UserSettings settings) {
    return UserSettingsFirestoreModel(
      locale: settings.locale.languageCode,
      createdAt: settings.createdAt,
      updatedAt: settings.updatedAt,
    );
  }
}
