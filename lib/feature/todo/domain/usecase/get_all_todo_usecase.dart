import 'package:injectable/injectable.dart';

import '../entity/todo.dart';
import '../repository/todo_repository.dart';

@injectable
class GetAllTodoUsecase {
  final TodoRepository _todoRepository;
  GetAllTodoUsecase({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  Future<List<Todo>> call() {
    return _todoRepository.getAll();
  }
}
