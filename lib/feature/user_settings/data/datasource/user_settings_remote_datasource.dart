import 'package:todo_app/feature/user_settings/data/model/user_settings_firestore_model.dart';

abstract class UserSettingsRemoteDataSource {
  Future<void> save(UserSettingsFirestoreModel model);
  Future<void> update(UserSettingsFirestoreModel model);
  Future<UserSettingsFirestoreModel?> get();
}
