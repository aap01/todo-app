import 'package:todo_app/feature/todo/domain/entity/todo_entity.dart';

abstract interface class TodoRepository {
  Future<void> add(String description);
  Future<void> remove(TodoEntity todoEntity);
  Future<void> update(TodoEntity todoEntity);
  Future<List<TodoEntity>> getAll();
}
