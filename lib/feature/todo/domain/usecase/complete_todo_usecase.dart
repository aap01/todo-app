import 'package:injectable/injectable.dart';
import 'package:todo_app/feature/todo/domain/repository/todo_repository.dart';

@injectable
class CompleteTodoUsecase {
  final TodoRepository _todoRepository;

  CompleteTodoUsecase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;
  void call(String id) {
    final todo = _todoRepository.findById(id);
    if (todo != null) {
      _todoRepository.update(todo.copyWith(isDone: true));
    }
  }
}
