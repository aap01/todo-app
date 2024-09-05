import 'dart:ui';

import '../entity/user_settings.dart';

abstract interface class UserSettingsRepository {
  Future<void> save({Locale? locale});
  Future<UserSettings> get();
  Future<void> sync();
}
