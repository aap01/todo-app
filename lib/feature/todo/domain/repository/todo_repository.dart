import 'package:todo_app/feature/todo/domain/entity/todo_entity.dart';

abstract interface class TodoRepository {
  void add(String description);
  void remove(String id);
  void update(TodoEntity todoEntity);
  TodoEntity? findById(String id);
  List<TodoEntity> getAll();
}
