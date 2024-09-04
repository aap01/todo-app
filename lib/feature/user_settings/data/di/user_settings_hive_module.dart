import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../model/user_settings_hive_model.dart';

@module
abstract class UserSettginsHiveModule {
  @preResolve
  Future<Box<UserSettingsHiveModel>> provideUserSettingsBox() async {
    Hive.registerAdapter(UserSettingsHiveModelAdapter());
    return Hive.openBox<UserSettingsHiveModel>('user_settings');
  }
}
