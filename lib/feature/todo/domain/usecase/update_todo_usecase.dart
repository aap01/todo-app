import '../repository/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateTodoUsecase {
  final TodoRepository _todoRepository;

  UpdateTodoUsecase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  Future<void> call(id, {String? description, bool? isDone}) =>
      _todoRepository.update(
        id,
        isDone: isDone,
        description: description,
      );
}
