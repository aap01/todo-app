import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/feature/user_settings/data/datasource/user_settings_remote_datasource.dart';
import 'package:todo_app/feature/user_settings/data/model/user_settings_firestore_model.dart';

@Injectable(as: UserSettingsRemoteDataSource)
class UserSettingsRemoteDatasourceImpl implements UserSettingsRemoteDataSource {
  static const _collectionName = 'user_settings';
  static const _key = 'user_settings';
  final FirebaseFirestore _firestore;

  UserSettingsRemoteDatasourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<UserSettingsFirestoreModel?> get() =>
      _firestore.collection(_collectionName).doc(_key).get().then(
            (value) => value.exists
                ? UserSettingsFirestoreModel.fromJson(value.data()!)
                : null,
          );

  @override
  Future<void> save(UserSettingsFirestoreModel model) =>
      _firestore.collection(_collectionName).doc(_key).set(model.toJson());

  @override
  Future<void> update(UserSettingsFirestoreModel model) =>
      _firestore.collection(_collectionName).doc(_key).update(model.toJson());
}
