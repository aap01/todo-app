import 'package:todo_app/feature/todo/data/model/todo_hive_model.dart';
import 'package:todo_app/feature/todo/domain/entity/todo_entity.dart';

import '../model/todo_firestore_model.dart';

abstract final class TodoMapper {
  static TodoHiveModel toHiveModel(TodoEntity todoEntity) => TodoHiveModel(
        id: todoEntity.id,
        description: todoEntity.description,
        isDone: todoEntity.isDone,
        createdAt: todoEntity.createdAt,
        updatedAt: todoEntity.updatedAt,
        isDeleted: todoEntity.isDeleted,
        doneStatusChangedAt: todoEntity.doneStatusChangedAt,
      );

  static TodoEntity fromHiveModel(TodoHiveModel todoHiveModel) => TodoEntity(
        id: todoHiveModel.id,
        description: todoHiveModel.description,
        isDone: todoHiveModel.isDone,
        createdAt: todoHiveModel.createdAt,
        updatedAt: todoHiveModel.updatedAt,
        isDeleted: todoHiveModel.isDeleted,
        doneStatusChangedAt: todoHiveModel.doneStatusChangedAt,
      );
  static TodoEntity fromFirestoreModel(TodoFirestoreModel todoFirestoreModel) =>
      TodoEntity(
        id: todoFirestoreModel.id,
        description: todoFirestoreModel.description,
        isDone: todoFirestoreModel.isDone,
        createdAt: todoFirestoreModel.createdAt,
        updatedAt: todoFirestoreModel.updatedAt,
        isDeleted: todoFirestoreModel.isDeleted,
        doneStatusChangedAt: todoFirestoreModel.doneStatusChangedAt,
      );

  static TodoFirestoreModel toFirestoreModel(TodoEntity todoEntity) =>
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
