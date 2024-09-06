import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo_app/feature/todo/domain/entity/todo.dart';

class TodoWidget extends StatelessWidget {
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final void Function(String?) onEdit;
  final Todo todoEntity;

  const TodoWidget({
    super.key,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    required this.todoEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
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
    );
  }
}
