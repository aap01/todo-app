import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../model/todo_hive_model.dart';

@module
abstract class TodoHiveModule {
  @preResolve
  Future<Box<TodoHiveModel>> provideTodoBox() async {
    Hive.registerAdapter(TodoHiveModelAdapter());
    return Hive.openBox<TodoHiveModel>(TodoHiveModel.boxName);
  }
}
