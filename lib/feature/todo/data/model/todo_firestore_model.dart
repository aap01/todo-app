import 'package:json_annotation/json_annotation.dart';

part 'todo_firestore_model.g.dart';

@JsonSerializable()
class TodoFirestoreModel {
  static const collectionPath = 'todo';
  final String id;
  final String description;
  final bool isDone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final DateTime doneStatusChangedAt;

  TodoFirestoreModel({
    required this.id,
    required this.description,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.doneStatusChangedAt,
  });

  factory TodoFirestoreModel.fromJson(Map<String, dynamic> json) =>
      _$TodoFirestoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodoFirestoreModelToJson(this);

  TodoFirestoreModel copyWith({
    String? id,
    String? description,
    bool? isDone,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? doneStatusChangedAt,
  }) {
    return TodoFirestoreModel(
      id: id ?? this.id,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      doneStatusChangedAt: doneStatusChangedAt ?? this.doneStatusChangedAt,
    );
  }
}
