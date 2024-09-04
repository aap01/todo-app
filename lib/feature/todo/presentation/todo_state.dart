import 'package:equatable/equatable.dart';

import '../domain/entity/todo.dart';

abstract class TodoState extends Equatable {
  final List<Todo> doneTodos;
  final List<Todo> incompleteTodos;

  const TodoState({
    required this.doneTodos,
    required this.incompleteTodos,
  });

  @override
  List<Object?> get props => [doneTodos, incompleteTodos];
}

class TodoInitialState extends TodoState {
  TodoInitialState() : super(doneTodos: [], incompleteTodos: []);
}

class TodoLoadedState extends TodoState {
  const TodoLoadedState({
    required super.doneTodos,
    required super.incompleteTodos,
  });
}
