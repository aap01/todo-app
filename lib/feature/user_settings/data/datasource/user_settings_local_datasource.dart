import '../model/user_settings_hive_model.dart';

abstract class UserSettingsLocalDataSource {
  Future<void> save(UserSettingsHiveModel model);
  Future<UserSettingsHiveModel?> get();
  Future<void> update(UserSettingsHiveModel model);
}
