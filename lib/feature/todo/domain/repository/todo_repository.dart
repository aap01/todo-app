import 'package:todo_app/feature/todo/domain/entity/todo_entity.dart';

abstract interface class TodoRepository {
  Future<void> add(String description);
  Future<void> remove(int id);
  Future<void> update(TodoEntity todoEntity);
  TodoEntity? findById(int id);
  Future<List<TodoEntity>> getAll();
}
