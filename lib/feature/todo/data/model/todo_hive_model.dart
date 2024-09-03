import 'package:hive/hive.dart';
part 'todo_hive_model.g.dart';

@HiveType(typeId: 0)
class TodoHiveModel {
  static String get boxName => 'todo';
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final bool isDone;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final DateTime updatedAt;
  @HiveField(5)
  final bool isDeleted;
  @HiveField(6)
  final DateTime doneStatusChangedAt;

  TodoHiveModel({
    required this.id,
    required this.description,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.doneStatusChangedAt,
  });
}
