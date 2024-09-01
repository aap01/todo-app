import '../entity/user_settings.dart';

abstract interface class UserSettingsRepository {
  Future<void> save(UserSettings userSettings);
  Future<UserSettings> get();
}
