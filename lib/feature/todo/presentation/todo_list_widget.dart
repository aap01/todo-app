import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo_app/feature/todo/presentation/todo_widget.dart';

import '../domain/entity/todo_entity.dart';

class TodoListWidget extends StatelessWidget {
  final List<TodoEntity> todos;
  final void Function(TodoEntity) onToggle;
  final void Function(TodoEntity) onDelete;
  final void Function(TodoEntity, String?) onEdit;
  final ScrollController? scrollController;

  const TodoListWidget({
    super.key,
    required this.todos,
    required this.onToggle,
    required this.scrollController,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      shrinkWrap: true,
      itemBuilder: (cxt, index) {
        final todoEntity = todos[index];
        return TodoWidget(
          todoEntity: todoEntity,
          onToggle: () => onToggle(todoEntity),
          onDelete: () => onDelete(todoEntity),
          onEdit: (description) => onEdit(todoEntity, description),
        );
      },
      separatorBuilder: (cxt, index) => const Gap(8),
      itemCount: todos.length,
    );
  }
}
