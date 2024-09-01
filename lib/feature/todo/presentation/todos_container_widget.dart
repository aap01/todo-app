import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:todo_app/feature/todo/presentation/add_todo_widget.dart';
import 'package:todo_app/feature/todo/presentation/todo_bloc.dart';
import 'package:todo_app/feature/todo/presentation/todo_list_widget.dart';
import 'package:todo_app/feature/todo/presentation/todo_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../di/dependency.dart';
import '../domain/entity/todo_entity.dart';

class TodosContainerWidget extends StatelessWidget {
  const TodosContainerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return BlocProvider(
      create: (context) => getIt<TodoBloc>()..loadTodos(),
      child: Builder(builder: (context) {
        final todoBloc = context.read<TodoBloc>();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: scrollController,
                  shrinkWrap: true,
                  children: [
                    BlocSelector<TodoBloc, TodoState, List<TodoEntity>>(
                      selector: (state) => state.incompleteTodos,
                      builder: (context, todos) {
                        return TodoListWidget(
                          scrollController: scrollController,
                          todos: todos,
                          onToggle: todoBloc.onToggleTodo,
                          onDelete: todoBloc.onDeleteTodo,
                          onEdit: todoBloc.onUpdateTodoDescription,
                        );
                      },
                    ),
                    BlocSelector<TodoBloc, TodoState, List<TodoEntity>>(
                      selector: (state) => state.doneTodos,
                      builder: (context, todos) {
                        if (todos.isEmpty) return const SizedBox();
                        return Column(
                          children: [
                            const Gap(32),
                            Chip(
                              label:
                                  Text(AppLocalizations.of(context)!.completed),
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const Gap(8),
                            TodoListWidget(
                              scrollController: scrollController,
                              todos: todos,
                              onToggle: todoBloc.onToggleTodo,
                              onDelete: todoBloc.onDeleteTodo,
                              onEdit: context
                                  .read<TodoBloc>()
                                  .onUpdateTodoDescription,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              AddTodoWidget(
                onAdd: todoBloc.onAdd,
              )
            ],
          ),
        );
      }),
    );
  }
}
