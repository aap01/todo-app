import 'package:todo_app/feature/todo/data/model/todo_hive_model.dart';

abstract interface class TodoLocalDataSource {
  Future<void> create(TodoHiveModel model);
  Future<void> update(TodoHiveModel model);
  Future<void> delete(String id);
  Future<List<TodoHiveModel>> getAll();
  Future<TodoHiveModel?> get(String id);
}
