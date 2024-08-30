import 'package:injectable/injectable.dart';
import 'package:todo_app/feature/todo/domain/repository/todo_repository.dart';

@injectable
class AddTodoUsecase {
  final TodoRepository _todoRepository;

  AddTodoUsecase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  void call(String description) => _todoRepository.add(description);
}
