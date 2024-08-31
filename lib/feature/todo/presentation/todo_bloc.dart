import 'package:injectable/injectable.dart';
import 'package:todo_app/feature/todo/presentation/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entity/todo_entity.dart';
import '../domain/usecase/add_todo_usecase.dart';
import '../domain/usecase/delete_todo_usecase.dart';
import '../domain/usecase/get_all_todo_usecase.dart';
import '../domain/usecase/update_todo_usecase.dart';

@injectable
class TodoBloc extends Cubit<TodoState> {
  final AddTodoUsecase _addTodoUsecase;
  final DeleteTodoUsecase _deleteTodoUsecase;
  final UpdateTodoUsecase _updateTodoUsecase;
  final GetAllTodoUsecase _getAllTodoUsecase;

  TodoBloc({
    required AddTodoUsecase addTodoUsecase,
    required DeleteTodoUsecase deleteTodoUsecase,
    required UpdateTodoUsecase updateTodoDescriptionUsecase,
    required GetAllTodoUsecase getAllTodoUsecase,
  })  : _addTodoUsecase = addTodoUsecase,
        _deleteTodoUsecase = deleteTodoUsecase,
        _updateTodoUsecase = updateTodoDescriptionUsecase,
        _getAllTodoUsecase = getAllTodoUsecase,
        super(TodoInitialState());

  Future<void> loadTodos() async {
    final todos = await _getAllTodoUsecase();
    final doneTodos = todos.where((todo) => todo.isDone).toList();
    final incompleteTodos = todos.where((todo) => !todo.isDone).toList();
    emit(
      TodoLoadedState(
        doneTodos: doneTodos,
        incompleteTodos: incompleteTodos,
      ),
    );
  }

  Future<void> onAdd(String? description) async {
    if (description == null) return;
    final trimmed = description.trim();
    if (trimmed.isEmpty) return;
    await _addTodoUsecase(description.trim());
    await loadTodos();
  }

  Future<void> onToggleTodo(TodoEntity todoEntity) async {
    await _updateTodoUsecase(todoEntity.copyWith(isDone: !todoEntity.isDone));
    await loadTodos();
  }

  Future<void> onDeleteTodo(TodoEntity todo) async {
    await _deleteTodoUsecase(todo);
    await loadTodos();
  }

  Future<void> onUpdateTodoDescription(
    TodoEntity todo,
    String? description,
  ) async {
    if (description == null) {
      await onDeleteTodo(todo);
      return;
    }
    final trimmed = description.trim();
    if (trimmed.isEmpty) {
      await onDeleteTodo(todo);
      return;
    }
    await _updateTodoUsecase(todo.copyWith(description: trimmed));
    await loadTodos();
  }
}
