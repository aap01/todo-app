import 'package:todo_app/feature/todo/domain/entity/todo_entity.dart';

abstract interface class TodoRepository {
  Future<void> add(String description);
  Future<void> remove(String id);
  Future<void> update(String id, {String? description, bool? isDone});
  Future<List<TodoEntity>> getAll();
  Future<void> sync();
}
