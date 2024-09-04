import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String description;
  final bool isDone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final DateTime doneStatusChangedAt;

  const Todo({
    required this.id,
    required this.description,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.doneStatusChangedAt,
  });

  factory Todo.create(String id, String description) {
    final now = DateTime.now();
    return Todo(
      id: id,
      description: description,
      isDone: false,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
      doneStatusChangedAt: now,
    );
  }

  @override
  List<Object?> get props => [
        id,
        description,
        isDone,
        createdAt,
        updatedAt,
        isDeleted,
        doneStatusChangedAt,
      ];

  Todo updateDescription(String? description) {
    if (description == null) {
      return this;
    }
    final trimmedDescription = description.trim();
    if (trimmedDescription.isEmpty) {
      return this;
    }
    return _copyWith(
      description: trimmedDescription,
      updatedAt: DateTime.now(),
    );
  }

  Todo updateDone(bool? isDone) {
    if (isDone == null) {
      return this;
    } else if (this.isDone == isDone) {
      return this;
    } else {
      final now = DateTime.now();
      if (isDone == true) {
        return _copyWith(
          isDone: isDone,
          doneStatusChangedAt: now,
          updatedAt: now,
        );
      } else {
        return _copyWith(
          isDone: isDone,
          doneStatusChangedAt: createdAt,
          updatedAt: now,
        );
      }
    }
  }

  Todo delete() {
    return _copyWith(
      isDeleted: true,
      updatedAt: DateTime.now(),
    );
  }

  Todo _copyWith({
    String? id,
    String? description,
    bool? isDone,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? doneStatusChangedAt,
  }) {
    return Todo(
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
