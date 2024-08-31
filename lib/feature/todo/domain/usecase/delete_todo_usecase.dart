import 'package:injectable/injectable.dart';

import '../entity/todo_entity.dart';
import '../repository/todo_repository.dart';

@injectable
class DeleteTodoUsecase {
  final TodoRepository _todoRepository;
  DeleteTodoUsecase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  Future<void> call(TodoEntity todoEntity) =>
      _todoRepository.remove(todoEntity);
}
