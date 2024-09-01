import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/feature/todo/presentation/todos_container_widget.dart';
import 'package:todo_app/feature/user_settings/presentation/locale_bloc.dart';

import '../../feature/user_settings/presentation/locale_state.dart';
import '../../feature/user_settings/presentation/locale_toggle_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

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
          BlocBuilder<LocaleBloc, LocaleState>(builder: (context, state) {
            return LocaleToggleWidget(
              locale: state.locale,
            );
          }),
        ],
      ),
      body: const SafeArea(
        child: TodosContainerWidget(),
      ),
    );
  }
}
