import '../model/todo_firestore_model.dart';

abstract class TodoRemoteDataSource {
  Future<void> save(TodoFirestoreModel model);
  Future<void> update(TodoFirestoreModel model);
  Future<void> delete(String id);
  Future<List<TodoFirestoreModel>> getAll();
  Future<void> sync({
    required List<String> deleteModelIds,
    required List<TodoFirestoreModel> updateModels,
    required List<TodoFirestoreModel> createModels,
  });
}
