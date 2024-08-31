import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTodoWidget extends StatefulWidget {
  final void Function(String) onAdd;
  const AddTodoWidget({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddTodoWidget> createState() => _AddTodoWidgetState();
}

class _AddTodoWidgetState extends State<AddTodoWidget> {
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
        ),
        hintText: AppLocalizations.of(context)!.addTodoHintText,
      ),
      onSubmitted: (value) {
        widget.onAdd(value);
        _textController.clear();
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
