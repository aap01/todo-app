import 'package:injectable/injectable.dart';

import '../entity/todo_entity.dart';
import '../repository/todo_repository.dart';

@injectable
class GetAllTodoUsecase {
  final TodoRepository _todoRepository;
  GetAllTodoUsecase({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  List<TodoEntity> call() {
    return _todoRepository.getAll();
  }
}
