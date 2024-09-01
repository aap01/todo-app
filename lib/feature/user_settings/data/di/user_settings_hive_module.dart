import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/feature/user_settings/data/model/user_settings_model.dart';

@module
abstract class UserSettginsHiveModule {
  @preResolve
  Future<Box<UserSettingsModel>> provideUserSettingsBox() async {
    Hive.registerAdapter(UserSettingsModelAdapter());
    return Hive.openBox<UserSettingsModel>('user_settings');
  }
}
