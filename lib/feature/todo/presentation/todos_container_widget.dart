import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:todo_app/feature/todo/presentation/add_todo_widget.dart';
import 'package:todo_app/feature/todo/presentation/todo_bloc.dart';
import 'package:todo_app/feature/todo/presentation/todo_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/feature/todo/presentation/todo_widget.dart';

import '../../../di/dependency.dart';
import '../domain/entity/todo.dart';

class TodosContainerWidget extends StatelessWidget {
  const TodosContainerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TodoBloc>()
        ..listenToBackgroundTask()
        ..loadTodos(),
      child: Builder(builder: (context) {
        final todoBloc = context.read<TodoBloc>();
        return Column(
          children: [
            BlocBuilder<TodoBloc, TodoState>(builder: (_, state) {
              final list = TodoListViewHolder.getList(
                state.incompleteTodos,
                state.doneTodos,
              );
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (_, index) {
                    final item = list[index];
                    return switch (item) {
                      DoneSeparator() => Column(
                          children: [
                            const Gap(8),
                            Chip(
                              label:
                                  Text(AppLocalizations.of(context)!.completed),
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          ],
                        ),
                      SectionGapHolder() => const Gap(8),
                      TodoHolder(todoEntity: var todo) => Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TodoWidget(
                                key: Key(todo.id),
                                todoEntity: todo,
                                onToggle: () => todoBloc.onToggleTodo(todo),
                                onDelete: () => todoBloc.onDeleteTodo(todo),
                                onEdit: (description) =>
                                    todoBloc.onUpdateTodoDescription(
                                  todo,
                                  description,
                                ),
                              ),
                            ),
                            const Gap(8),
                          ],
                        ),
                    };
                  },
                  itemCount: list.length,
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 16.0,
              ),
              child: AddTodoWidget(
                onAdd: todoBloc.onAdd,
              ),
            ),
          ],
        );
      }),
    );
  }
}

sealed class TodoListViewHolder {
  static List<TodoListViewHolder> getList(
    List<Todo> incompleteTodos,
    List<Todo> doneTodos,
  ) =>
      <TodoListViewHolder>[
        if (incompleteTodos.isNotEmpty) SectionGapHolder(),
        ...incompleteTodos.map((e) => TodoHolder(e)),
        if (incompleteTodos.isNotEmpty) SectionGapHolder(),
        if (doneTodos.isNotEmpty) DoneSeparator(),
        SectionGapHolder(),
        ...doneTodos.map((e) => TodoHolder(e)),
      ];
}

class DoneSeparator extends TodoListViewHolder {}

class SectionGapHolder extends TodoListViewHolder {}

class TodoHolder extends TodoListViewHolder {
  final Todo todoEntity;
  TodoHolder(this.todoEntity);
}
