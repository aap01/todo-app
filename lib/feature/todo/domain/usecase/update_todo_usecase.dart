import '../entity/todo_entity.dart';
import '../repository/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateTodoUsecase {
  final TodoRepository _todoRepository;

  UpdateTodoUsecase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  Future<void> call(TodoEntity todoEntity) =>
      _todoRepository.update(todoEntity);
}
