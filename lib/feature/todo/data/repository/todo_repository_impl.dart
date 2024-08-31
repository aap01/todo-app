import 'package:hive/hive.dart';
import 'package:todo_app/feature/todo/domain/entity/todo_entity.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repository/todo_repository.dart';

import 'package:injectable/injectable.dart';

import '../model/todo_model.dart';

@Injectable(as: TodoRepository)
class TodoReositoryImpl implements TodoRepository {
  final Box<TodoModel> _todoBox;
  final Uuid _uuid;

  @factoryMethod
  TodoReositoryImpl({
    required Box<TodoModel> todoBox,
    required Uuid uuid,
  })  : _todoBox = todoBox,
        _uuid = uuid;

  @override
  Future<void> add(String description) async {
    final todoModel = TodoModel(
      id: _uuid.v4(),
      description: description,
      isDone: false,
    );
    await _todoBox.add(todoModel);
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
  Future<void> remove(TodoEntity todoEntity) async {
    final index = _getHiveIndex(todoEntity.id);
    if (index == null) {
      return;
    }
    await _todoBox.deleteAt(index);
  }

  @override
  Future<void> update(TodoEntity todoEntity) async {
    final index = _getHiveIndex(todoEntity.id);
    if (index == null) {
      return;
    }
    final todoModel = TodoModel(
      id: todoEntity.id,
      description: todoEntity.description,
      isDone: todoEntity.isDone,
    );
    await _todoBox.put(index, todoModel);
  }

  int? _getHiveIndex(String id) {
    try {
      final index =
          _todoBox.values.indexed.where((e) => e.$2.id == id).first.$1;
      return index;
    } catch (e) {
      return null;
      // TODO: report this to crashlytics
    }
  }
}
