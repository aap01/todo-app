import '../repository/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UndoCompleteTodoUsecase {
  final TodoRepository _todoRepository;

  UndoCompleteTodoUsecase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  Future<void> call(int id) async {
    final todo = _todoRepository.findById(id);
    if (todo != null) {
      _todoRepository.update(todo.copyWith(isDone: false));
    }
  }
}
