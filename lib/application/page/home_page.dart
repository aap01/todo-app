import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/feature/todo/presentation/todos_container_widget.dart';

import '../../feature/user_settings/presentation/locale_toggle_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
    required this.locale,
  });

  final String title;
  final Locale locale;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          LocaleToggleWidget(
            locale: widget.locale,
          ),
          // const Gap(16),
        ],
      ),
      body: const SafeArea(
        child: TodosContainerWidget(),
      ),
    );
  }
}
