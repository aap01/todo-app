import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/feature/user_settings/data/datasource/user_settings_local_datasource.dart';
import 'package:todo_app/feature/user_settings/data/model/user_settings_hive_model.dart';

@Injectable(as: UserSettingsLocalDataSource)
class UserSettingsLocalDatasourceImpl implements UserSettingsLocalDataSource {
  final Box<UserSettingsHiveModel> _box;
  static const _key = 'user_settings';

  UserSettingsLocalDatasourceImpl({
    required Box<UserSettingsHiveModel> box,
  }) : _box = box;

  @override
  Future<UserSettingsHiveModel?> get() async {
    return _box.get(_key);
  }

  @override
  Future<void> save(UserSettingsHiveModel model) async {
    await _box.put(_key, model);
  }

  @override
  Future<void> update(UserSettingsHiveModel model) async {
    await _box.put(_key, model);
  }
}
