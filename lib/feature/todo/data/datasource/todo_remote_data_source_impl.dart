import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/feature/todo/data/datasource/todo_remote_data_source.dart';
import 'package:todo_app/feature/todo/data/model/todo_firestore_model.dart';

@Injectable(as: TodoRemoteDataSource)
class TodoRemoteDatasourceImpl implements TodoRemoteDataSource {
  static const _collectionName = 'todo';

  final FirebaseFirestore _firestore;

  TodoRemoteDatasourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<void> delete(String id) =>
      _firestore.collection(_collectionName).doc(id).delete();

  @override
  Future<List<TodoFirestoreModel>> getAll() {
    return _firestore.collection(_collectionName).get().then(
          (value) => value.docs
              .map((e) => TodoFirestoreModel.fromJson(e.data()))
              .toList(),
        );
  }

  @override
  Future<void> save(TodoFirestoreModel model) =>
      _firestore.collection(_collectionName).doc(model.id).set(model.toJson());

  @override
  Future<void> update(TodoFirestoreModel model) => _firestore
      .collection(_collectionName)
      .doc(model.id)
      .update(model.toJson());

  @override
  Future<void> sync({
    required List<String> deleteModelIds,
    required List<TodoFirestoreModel> updateModels,
    required List<TodoFirestoreModel> createModels,
  }) async {
    final batch = _firestore.batch();

    for (final id in deleteModelIds) {
      batch.delete(
        _firestore.collection(_collectionName).doc(id),
      );
    }

    for (final model in updateModels) {
      batch.update(
        _firestore.collection(_collectionName).doc(model.id),
        model.toJson(),
      );
    }

    for (final model in createModels) {
      batch.set(
        _firestore.collection(_collectionName).doc(model.id),
        model.toJson(),
      );
    }
    await batch.commit().then(
      (_) {
        debugPrint('sync success with');
      },
      onError: (error) => debugPrint(error),
    );
  }
}
