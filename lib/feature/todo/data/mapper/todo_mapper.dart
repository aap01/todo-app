import 'package:todo_app/feature/todo/data/model/todo_hive_model.dart';
import 'package:todo_app/feature/todo/domain/entity/todo.dart';

import '../model/todo_firestore_model.dart';

abstract final class TodoMapper {
  static TodoHiveModel toHiveModel(Todo todoEntity) => TodoHiveModel(
        id: todoEntity.id,
        description: todoEntity.description,
        isDone: todoEntity.isDone,
        createdAt: todoEntity.createdAt,
        updatedAt: todoEntity.updatedAt,
        isDeleted: todoEntity.isDeleted,
        doneStatusChangedAt: todoEntity.doneStatusChangedAt,
      );

  static Todo fromHiveModel(TodoHiveModel todoHiveModel) => Todo(
        id: todoHiveModel.id,
        description: todoHiveModel.description,
        isDone: todoHiveModel.isDone,
        createdAt: todoHiveModel.createdAt,
        updatedAt: todoHiveModel.updatedAt,
        isDeleted: todoHiveModel.isDeleted,
        doneStatusChangedAt: todoHiveModel.doneStatusChangedAt,
      );
  static Todo fromFirestoreModel(TodoFirestoreModel todoFirestoreModel) => Todo(
        id: todoFirestoreModel.id,
        description: todoFirestoreModel.description,
        isDone: todoFirestoreModel.isDone,
        createdAt: todoFirestoreModel.createdAt,
        updatedAt: todoFirestoreModel.updatedAt,
        isDeleted: todoFirestoreModel.isDeleted,
        doneStatusChangedAt: todoFirestoreModel.doneStatusChangedAt,
      );

  static TodoFirestoreModel toFirestoreModel(Todo todoEntity) =>
      TodoFirestoreModel(
        id: todoEntity.id,
        description: todoEntity.description,
        isDone: todoEntity.isDone,
        createdAt: todoEntity.createdAt,
        updatedAt: todoEntity.updatedAt,
        isDeleted: todoEntity.isDeleted,
        doneStatusChangedAt: todoEntity.doneStatusChangedAt,
      );
}
