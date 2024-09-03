// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_firestore_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoFirestoreModel _$TodoFirestoreModelFromJson(Map<String, dynamic> json) =>
    TodoFirestoreModel(
      id: json['id'] as String,
      description: json['description'] as String,
      isDone: json['isDone'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isDeleted: json['isDeleted'] as bool,
      doneStatusChangedAt:
          DateTime.parse(json['doneStatusChangedAt'] as String),
    );

Map<String, dynamic> _$TodoFirestoreModelToJson(TodoFirestoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'isDone': instance.isDone,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'doneStatusChangedAt': instance.doneStatusChangedAt.toIso8601String(),
    };
