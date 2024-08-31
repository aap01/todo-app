import 'package:injectable/injectable.dart';

import '../repository/todo_repository.dart';

@injectable
class DeleteTodoUsecase {
  final TodoRepository _todoRepository;
  DeleteTodoUsecase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  Future<void> call(int id) => _todoRepository.remove(id);
}
