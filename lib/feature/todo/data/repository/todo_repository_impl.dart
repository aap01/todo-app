import 'package:hive/hive.dart';
import 'package:todo_app/feature/todo/domain/entity/todo_entity.dart';

import '../../domain/repository/todo_repository.dart';

import 'package:injectable/injectable.dart';

import '../model/todo_model.dart';

@Injectable(as: TodoRepository)
class TodoReositoryImpl implements TodoRepository {
  final Box<TodoModel> _todoBox;

  @factoryMethod
  TodoReositoryImpl({
    required Box<TodoModel> todoBox,
  }) : _todoBox = todoBox;

  @override
  Future<void> add(String description) async {
    final todoModel = TodoModel(
      description: description,
      isDone: false,
    );
    final id = await _todoBox.add(todoModel);
    await _todoBox.put(id, todoModel.copyWith(id: id));
  }

  @override
  TodoEntity? findById(int id) {
    final todoModel = _todoBox.get(id);
    if (todoModel != null) {
      return TodoEntity(
        id: todoModel.id,
        description: todoModel.description,
        isDone: todoModel.isDone,
      );
    }
    return null;
  }

  @override
  Future<List<TodoEntity>> getAll() async {
    return _todoBox.values
        .map(
          (e) => TodoEntity(
            id: e.id,
            description: e.description,
            isDone: e.isDone,
          ),
        )
        .toList();
  }

  @override
  Future<void> remove(int id) async {
    _todoBox.deleteAt(id);
  }

  @override
  Future<void> update(TodoEntity todoEntity) async {
    final todoModel = TodoModel(
      id: todoEntity.id,
      description: todoEntity.description,
      isDone: todoEntity.isDone,
    );
    await _todoBox.put(todoEntity.id, todoModel);
  }
}
