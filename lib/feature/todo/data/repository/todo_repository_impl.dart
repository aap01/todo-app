import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/feature/todo/data/model/todo_firestore_model.dart';
import 'package:todo_app/feature/todo/domain/entity/todo_entity.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repository/todo_repository.dart';

import 'package:injectable/injectable.dart';

import '../model/todo_hive_model.dart';

@Injectable(as: TodoRepository)
class TodoReositoryImpl implements TodoRepository {
  final Box<TodoHiveModel> _todoBox;
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  @factoryMethod
  TodoReositoryImpl({
    required Box<TodoHiveModel> todoBox,
    required Uuid uuid,
    required FirebaseFirestore firestore,
  })  : _todoBox = todoBox,
        _firestore = firestore,
        _uuid = uuid;

  @override
  Future<void> add(String description) async {
    final todo = TodoEntity.create(_uuid.v4(), description);
    await _todoBox.put(todo.id, todo.toHiveModel());
  }

  @override
  Future<List<TodoEntity>> getAll() async {
    final localTodos =
        _todoBox.values.map((e) => TodoEntity.fromHiveModel(e)).toList();
    return localTodos;
  }

  @override
  Future<void> remove(String id) async {
    final model = _todoBox.get(id);
    if (model == null) {
      return;
    }
    final entity = TodoEntity.fromHiveModel(model);
    await _todoBox.put(entity.id, entity.delete().toHiveModel());
  }

  @override
  Future<void> update(
    String id, {
    String? description,
    bool? isDone,
  }) async {
    final model = _todoBox.get(id);
    if (model == null) {
      return;
    }
    final entity = TodoEntity.fromHiveModel(model)
        .updateDescription(description)
        .updateDone(isDone);
    await _todoBox.put(model.id, entity.toHiveModel());
  }

  @override
  Future<void> sync() async {
    // Fetch todos
    final localTodos =
        _todoBox.values.map((e) => TodoEntity.fromHiveModel(e)).toList();
    final firestoreTodos = await _getFirestoreTodos();

    // Create maps for easy lookup
    final localTodosMap = {for (var todo in localTodos) todo.id: todo};
    final firestoreTodosMap = {for (var todo in firestoreTodos) todo.id: todo};

    // Sync Firestore todos to local storage
    for (var firestoreTodo in firestoreTodos) {
      final localTodo = localTodosMap[firestoreTodo.id];
      if (localTodo == null) {
        // Add missing Firestore todo to local storage
        await _todoBox.put(firestoreTodo.id, firestoreTodo.toHiveModel());
      } else if (localTodo != firestoreTodo) {
        // Update local todo if content differs
        await _todoBox.put(firestoreTodo.id, firestoreTodo.toHiveModel());
      }
    }

    // Sync local todos to Firestore
    for (var localTodo in localTodos) {
      final firestoreTodo = firestoreTodosMap[localTodo.id];
      if (firestoreTodo == null) {
        // Add missing local todo to Firestore
        await _addTodoToFirestore(localTodo.toFirestoreModel());
      }
    }
  }

  Future<List<TodoEntity>> _getFirestoreTodos() async {
    final querySnapshot =
        await _firestore.collection(TodoFirestoreModel.collectionPath).get();
    final firestoreTodos = querySnapshot.docs.map((e) =>
        TodoEntity.fromFirestoreModel(TodoFirestoreModel.fromJson(e.data())));
    return firestoreTodos.toList();
  }

  Future<void> _addTodoToFirestore(TodoFirestoreModel model) async {
    await _firestore
        .collection(TodoFirestoreModel.collectionPath)
        .doc(model.id)
        .set(model.toJson());
  }
}
