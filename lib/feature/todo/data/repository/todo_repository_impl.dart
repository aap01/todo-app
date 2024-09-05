import 'package:flutter/foundation.dart';
import 'package:todo_app/feature/todo/domain/entity/todo.dart';
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
    final todo = Todo.create(_uuid.v4(), description);
    await _localDataSource.create(TodoMapper.toHiveModel(todo));
  }

  @override
  Future<List<Todo>> getAll() async {
    return (await _localDataSource.getAll())
        .map(TodoMapper.fromHiveModel)
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

    // 2. Accumulate deletable todos
    final remoteTodoMap = {for (var todo in remoteTodos) todo.id: todo};
    final localTodoMap = {for (var todo in localTodos) todo.id: todo};

    // a. deletableLocalTodos
    //    - todos that are marked with isDeleted to true in localTodosList
    //    - todos that are not marked with isDeleted to true in localTodosList
    //      but with same id marked isDeleted in remoteTodoList
    final deletableLocalTodos = localTodos
        .where((localTodo) {
          return localTodo.isDeleted ||
              (remoteTodoMap.containsKey(localTodo.id) &&
                  remoteTodoMap[localTodo.id]!.isDeleted);
        })
        .map((e) => e.id)
        .toList();

    // b. deletableRemoteTodos
    //    - todos that are marked with isDeleted to true in remoteTodosList
    //    - todos that are not marked with isDeleted to true in remoteTodosList
    //      but with same id marked isDeleted in localTodoList
    final deletableRemoteTodos = remoteTodos
        .where((remoteTodo) {
          return remoteTodo.isDeleted ||
              (localTodoMap.containsKey(remoteTodo.id) &&
                  localTodoMap[remoteTodo.id]!.isDeleted);
        })
        .map((e) => e.id)
        .toList();

    // 3. Deal with conflicting todos
    // a. latestLocalTodos to send to remote
    final latestLocalTodos = localTodos
        .where((localTodo) {
          final remoteTodo = remoteTodoMap[localTodo.id];
          if (remoteTodo == null) {
            return false;
          }
          return !localTodo.isDeleted &&
              !remoteTodo.isDeleted &&
              localTodo != remoteTodo &&
              localTodo.updatedAt.isAfter(remoteTodo.updatedAt);
        })
        .map(TodoMapper.toFirestoreModel)
        .toList();

    // a. latestRemoteTodos to put in local
    final latestRemoteTodos = remoteTodos
        .where((remoteTodo) {
          final localTodo = localTodoMap[remoteTodo.id];
          return !remoteTodo.isDeleted &&
              localTodo != null &&
              !localTodo.isDeleted &&
              remoteTodo != localTodo &&
              remoteTodo.updatedAt.isAfter(localTodo.updatedAt);
        })
        .map(TodoMapper.toHiveModel)
        .toList();

    // 4. Deal with non-conflicting todos
    final nonConflictingLocalTodos = localTodos
        .where((localTodo) {
          return !remoteTodoMap.containsKey(localTodo.id) &&
              !localTodo.isDeleted;
        })
        .map(TodoMapper.toFirestoreModel)
        .toList();

    final nonConflictingRemoteTodos = remoteTodos
        .where((remoteTodo) {
          return !localTodoMap.containsKey(remoteTodo.id) &&
              !remoteTodo.isDeleted;
        })
        .map(TodoMapper.toHiveModel)
        .toList();

    // Sync
    debugPrint('deleletableRemoteTodos: $deletableRemoteTodos');
    debugPrint('latestLocalTodos: $latestLocalTodos');
    debugPrint('nonConflictingLocalTodos: $nonConflictingLocalTodos');
    debugPrint('deletableLocalTodos: $deletableLocalTodos');
    debugPrint('latestRemoteTodos: $latestRemoteTodos');
    debugPrint('nonConflictingRemoteTodos: $nonConflictingRemoteTodos');
    await Future.wait([
      _remoteDataSource.sync(
        deleteModelIds: deletableRemoteTodos,
        updateModels: latestLocalTodos,
        createModels: nonConflictingLocalTodos,
      ),
      _localDataSource.sync(
        deleteModelIds: deletableLocalTodos,
        updateModels: latestRemoteTodos,
        createModels: nonConflictingRemoteTodos,
      ),
    ]);
  }
}
