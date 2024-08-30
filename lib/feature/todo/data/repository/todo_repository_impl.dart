import 'package:todo_app/feature/todo/domain/entity/todo_entity.dart';

import '../../domain/repository/todo_repository.dart';

import 'package:injectable/injectable.dart';

@Injectable(as: TodoRepository)
class TodoReositoryImpl implements TodoRepository {
  static final _todoList = [
    const TodoEntity(id: '0', description: 'Todo 1', isDone: false),
    const TodoEntity(id: '1', description: 'Todo 2', isDone: true),
    const TodoEntity(id: '2', description: 'Todo 3', isDone: false),
    const TodoEntity(id: '3', description: 'Todo 4', isDone: true),
    const TodoEntity(id: '4', description: 'Todo 5', isDone: false),
    const TodoEntity(id: '5', description: 'Todo 6', isDone: true),
  ];

  @override
  void add(String description) {
    _todoList.add(
      TodoEntity(
        id: _todoList.length.toString(),
        description: description,
        isDone: false,
      ),
    );
  }

  @override
  TodoEntity? findById(String id) {
    return _todoList.firstWhere((element) => element.id == id);
  }

  @override
  List<TodoEntity> getAll() {
    return _todoList;
  }

  @override
  void remove(String id) {
    _todoList.removeWhere((element) => element.id == id);
  }

  @override
  void update(TodoEntity todoEntity) {
    final index =
        _todoList.indexWhere((element) => element.id == todoEntity.id);
    if (index != -1) {
      _todoList[index] = todoEntity;
    }
  }
}
