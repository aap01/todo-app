import 'package:flutter/foundation.dart';
import 'package:todo_app/feature/todo/domain/entity/todo_entity.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repository/todo_repository.dart';

import 'package:injectable/injectable.dart';

import '../datasource/todo_local_data_source.dart';
import '../datasource/todo_remote_data_source.dart';
import '../mapper/todo_mapper.dart';
import '../model/todo_firestore_model.dart';
import '../model/todo_hive_model.dart';

@Injectable(as: TodoRepository)
class TodoReositoryImpl implements TodoRepository {
  final TodoLocalDataSource _localDataSource;
  final TodoRemoteDataSource _remoteDataSource;
  final Uuid _uuid;

  TodoReositoryImpl({
    required TodoLocalDataSource localDataSource,
    required TodoRemoteDataSource remoteDataSource,
    required Uuid uuid,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _uuid = uuid;

  @override
  Future<void> add(String description) async {
    final todo = TodoEntity.create(_uuid.v4(), description);
    await _localDataSource.create(TodoMapper.toHiveModel(todo));
  }

  @override
  Future<List<TodoEntity>> getAll() async {
    return (await _localDataSource.getAll())
        .map((e) => TodoMapper.fromHiveModel(e))
        .toList();
  }

  @override
  Future<void> remove(String id) async {
    final model = await _localDataSource.get(id);
    if (model == null) {
      return;
    }
    final todo = TodoMapper.fromHiveModel(model).delete();
    await _localDataSource.update(TodoMapper.toHiveModel(todo));
  }

  @override
  Future<void> update(
    String id, {
    String? description,
    bool? isDone,
  }) async {
    final model = await _localDataSource.get(id);
    if (model == null) {
      return;
    }
    final todo = TodoMapper.fromHiveModel(model)
        .updateDescription(description)
        .updateDone(isDone);
    await _localDataSource.update(TodoMapper.toHiveModel(todo));
  }

  @override
  Future<void> sync() async {
    debugPrint('Syncing todos');
    // 1. Accumulate todos from local store and remote database
    // 2. Accumulate deletable todos
    //    - todos that are marked with isDeleted to true
    //    - before deleting the todo in local database it must be
    //      successfully deleted from remote database
    //    - delete the rest remote todos that are marked with
    //      isDeleted to true
    // 3. Deal with confliting todos
    //    - when a local todo has the same id as
    //      that of the remote but their content do not match
    //    - if the local todo is updated later than the remote todo,
    //      remote todo is replacable with the local todo;
    //      make a list of latest local todos to write to the remote database
    //    - similarly make list of latest remote todos to write to the local database
    // 4. Deal with non-conflicting todos
    //    - a todo is only present in one of the local or remote database
    //    - put the todo in the other database

    // Fetch all todos from remote and local data sources in parallel
    final Future<List<TodoFirestoreModel>> remoteTodosFuture =
        _remoteDataSource.getAll();
    final Future<List<TodoHiveModel>> localTodosFuture =
        _localDataSource.getAll();

    final (remoteModels, localModels) = await (
      remoteTodosFuture,
      localTodosFuture,
    ).wait;

    final remoteTodos =
        remoteModels.map(TodoMapper.fromFirestoreModel).toList();
    final localTodos = localModels.map(TodoMapper.fromHiveModel).toList();

    // 1. Accumulate todos from local store and remote database
    final allTodos = <TodoEntity>{...localTodos, ...remoteTodos};

    // 2. Accumulate deletable todos
    final deletableTodos = allTodos.where((todo) => todo.isDeleted).toList();

    // Parallelize deletions
    await Future.wait(deletableTodos.map((todo) async {
      if (remoteTodos.contains(todo)) {
        await _remoteDataSource.delete(todo.id);
      }
      if (localTodos.contains(todo)) {
        await _localDataSource.delete(todo.id);
      }
    }));

    // 3. Deal with conflicting todos
    final latestLocalTodos = [];
    final latestRemoteTodos = [];

    for (var localTodo in localTodos) {
      remoteTodos
          .where(
        (todo) => todo.id == localTodo.id,
      )
          .forEach((remoteTodo) {
        if (remoteTodo != null && localTodo != remoteTodo) {
          if (localTodo.updatedAt.isAfter(remoteTodo.updatedAt)) {
            latestLocalTodos.add(localTodo);
          } else {
            latestRemoteTodos.add(remoteTodo);
          }
        }
      });
    }

    // Parallelize updates
    await Future.wait([
      ...latestLocalTodos.map((todo) => _remoteDataSource.update(todo)),
      ...latestRemoteTodos.map((todo) => _localDataSource.update(todo)),
    ]);

    // 4. Deal with non-conflicting todos
    final nonConflictingLocalTodos = localTodos
        .where((localTodo) =>
            !remoteTodos.any((remoteTodo) => remoteTodo.id == localTodo.id))
        .toList();
    final nonConflictingRemoteTodos = remoteTodos
        .where((remoteTodo) =>
            !localTodos.any((localTodo) => localTodo.id == remoteTodo.id))
        .toList();

    // Parallelize creations
    await Future.wait([
      ...nonConflictingLocalTodos.map(
          (todo) => _remoteDataSource.save(TodoMapper.toFirestoreModel(todo))),
      ...nonConflictingRemoteTodos
          .map((todo) => _localDataSource.create(TodoMapper.toHiveModel(todo))),
    ]);
  }
}
