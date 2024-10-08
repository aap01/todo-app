import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app/feature/todo/presentation/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/service/service_port_names.dart';
import '../domain/entity/todo.dart';
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
  final ReceivePort _receivePort;

  @factoryMethod
  TodoBloc({
    required AddTodoUsecase addTodoUsecase,
    required DeleteTodoUsecase deleteTodoUsecase,
    required UpdateTodoUsecase updateTodoDescriptionUsecase,
    required GetAllTodoUsecase getAllTodoUsecase,
    @Named(ServicePortNames.todo) required ReceivePort receivePort,
  })  : _receivePort = receivePort,
        _addTodoUsecase = addTodoUsecase,
        _deleteTodoUsecase = deleteTodoUsecase,
        _updateTodoUsecase = updateTodoDescriptionUsecase,
        _getAllTodoUsecase = getAllTodoUsecase,
        super(TodoInitialState());

  void listenToBackgroundTask() {
    // TODO: separate into multiple classes TodoWebBloc, TodoMobileBloc
    if (kIsWeb) {
      return;
    } else {
      final isSuccess = IsolateNameServer.registerPortWithName(
          _receivePort.sendPort, ServicePortNames.todo);
      if (isSuccess) {
        debugPrint('ready to receive data from background for $runtimeType');
        _receivePort.listen((data) {
          if (data == true) loadTodos();
        });
      } else {
        IsolateNameServer.removePortNameMapping(ServicePortNames.todo)
            ? debugPrint('removed port')
            : debugPrint('port not removed');
        listenToBackgroundTask();
        debugPrint('failed to register port');
      }
    }
  }

  Future<void> loadTodos() async {
    final todos = await _getAllTodoUsecase();

    final activeTodos = todos.where((e) => !e.isDeleted);

    // item created later shows up last
    final incompleteTodos = activeTodos.where((todo) => !todo.isDone).toList()
      ..sort((a, b) => a.createdAt.isBefore(b.createdAt) ? -1 : 1);

    // item done later shows up first
    final doneTodos = activeTodos.where((todo) => todo.isDone).toList()
      ..sort((a, b) =>
          a.doneStatusChangedAt.isBefore(b.doneStatusChangedAt) ? 1 : -1);
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
    await _addTodoUsecase(trimmed);
    await loadTodos();
  }

  Future<void> onToggleTodo(Todo todoEntity) async {
    await _updateTodoUsecase(todoEntity.id, isDone: !todoEntity.isDone);
    await loadTodos();
  }

  Future<void> onDeleteTodo(Todo todo) async {
    await _deleteTodoUsecase(todo.id);
    await loadTodos();
  }

  Future<void> onUpdateTodoDescription(
    Todo todo,
    String? description,
  ) async {
    if (description == null ||
        description.trim().isEmpty ||
        description.trim() == todo.description) {
      return;
    }
    await _updateTodoUsecase(
      todo.id,
      description: description.trim(),
    );
    await loadTodos();
  }
}
