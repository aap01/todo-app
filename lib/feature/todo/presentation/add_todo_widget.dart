import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTodoWidget extends StatelessWidget {
  final void Function(String) onAdd;
  const AddTodoWidget({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
        ),
        hintText: AppLocalizations.of(context)!.addTodoHintText,
      ),
      onSubmitted: onAdd,
    );
  }
}
