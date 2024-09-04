import '../model/todo_firestore_model.dart';

abstract class TodoRemoteDataSource {
  Future<void> save(TodoFirestoreModel model);
  Future<void> update(TodoFirestoreModel model);
  Future<void> delete(String id);
  Future<List<TodoFirestoreModel>> getAll();
}
