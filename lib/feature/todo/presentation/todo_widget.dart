import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo_app/feature/todo/domain/entity/todo_entity.dart';

class TodoWidget extends StatelessWidget {
  final TodoEntity todoEntity;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final void Function(String?) onEdit;

  const TodoWidget({
    super.key,
    required this.todoEntity,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      transitionOnUserGestures: true,
      tag: todoEntity.id,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            InkWell(
              onTap: onToggle,
              child: Icon(
                todoEntity.isDone
                    ? Icons.check_circle_sharp
                    : Icons.circle_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Gap(8),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                initialValue: todoEntity.description,
                style: TextStyle(
                  decoration: todoEntity.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
                onFieldSubmitted: onEdit,
              ),
            ),
            const Gap(8),
            InkWell(
              onTap: () => onDelete(),
              child: Icon(
                Icons.delete_outlined,
                color: Theme.of(context).colorScheme.primary.withRed(150),
              ),
            )
          ],
        ),
      ),
    );
  }
}
