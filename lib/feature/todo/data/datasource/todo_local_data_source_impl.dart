import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/feature/todo/data/datasource/todo_local_data_source.dart';
import 'package:todo_app/feature/todo/data/model/todo_hive_model.dart';

@Injectable(as: TodoLocalDataSource)
class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final Box<TodoHiveModel> _box;

  TodoLocalDataSourceImpl({
    required Box<TodoHiveModel> box,
  }) : _box = box;

  @override
  Future<void> delete(String id) async {
    return _box.delete(id);
  }

  @override
  Future<List<TodoHiveModel>> getAll() => Future.value(_box.values.toList());

  @override
  Future<void> update(TodoHiveModel model) => _box.put(model.id, model);

  @override
  Future<void> create(TodoHiveModel model) => _box.put(model.id, model);

  @override
  Future<TodoHiveModel?> get(String id) => Future.value(_box.get(id));
}
