import 'package:hive/hive.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final bool isDone;

  TodoModel({
    required this.id,
    required this.description,
    required this.isDone,
  });

  TodoModel copyWith({
    String? id,
    String? description,
    bool? isDone,
  }) {
    return TodoModel(
      id: id ?? this.id,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }
}
