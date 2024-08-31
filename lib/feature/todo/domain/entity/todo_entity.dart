import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final int id;
  final String description;
  final bool isDone;

  const TodoEntity({
    required this.id,
    required this.description,
    required this.isDone,
  });

  @override
  List<Object?> get props => [
        id,
        description,
        isDone,
      ];

  TodoEntity copyWith({
    int? id,
    String? description,
    bool? isDone,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }
}
