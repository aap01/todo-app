import '../repository/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateTodoDescriptionUsecase {
  final TodoRepository _todoRepository;

  UpdateTodoDescriptionUsecase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  Future<void> call(int id, String description) async {
    final todo = _todoRepository.findById(id);
    if (todo != null) {
      await _todoRepository.update(todo.copyWith(description: description));
    }
  }
}
