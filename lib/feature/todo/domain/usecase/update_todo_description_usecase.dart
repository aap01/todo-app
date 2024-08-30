import '../repository/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateTodoDescriptionUsecase {
  final TodoRepository _todoRepository;

  UpdateTodoDescriptionUsecase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  void call(String id, String description) {
    final todo = _todoRepository.findById(id);
    if (todo != null) {
      _todoRepository.update(todo.copyWith(description: description));
    }
  }
}
