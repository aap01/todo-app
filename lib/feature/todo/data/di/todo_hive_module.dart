import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../model/todo_model.dart';

@module
abstract class TodoHiveModule {
  @preResolve
  @singleton
  Future<Box<TodoModel>> provideTodoBox() async {
    Hive.registerAdapter(TodoModelAdapter());
    return Hive.openBox<TodoModel>('todo');
  }
}
