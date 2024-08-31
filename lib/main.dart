import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/di/dependency.dart';
import 'package:todo_app/feature/todo/domain/entity/todo_entity.dart';
import 'package:todo_app/feature/todo/presentation/add_todo_widget.dart';
import 'package:todo_app/feature/todo/presentation/todo_list_widget.dart';
import 'package:todo_app/feature/todo/presentation/todo_state.dart';

import 'feature/todo/presentation/todo_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    Hive.init(null);
  } else {
    Hive.init((await getApplicationDocumentsDirectory()).path);
  }
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<TodoBloc>()..loadTodos(),
          ),
        ],
        child: const MyHomePage(title: 'Todo App'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();

  late TodoBloc _todoBloc;

  @override
  void dispose() {
    _todoBloc.close();
    _scrollController.dispose();
    Hive.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _todoBloc = context.read<TodoBloc>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  children: [
                    BlocSelector<TodoBloc, TodoState, List<TodoEntity>>(
                      selector: (state) => state.incompleteTodos,
                      builder: (context, todos) {
                        return TodoListWidget(
                          scrollController: _scrollController,
                          todos: todos,
                          onToggle: _todoBloc.onToggleTodo,
                          onDelete: _todoBloc.onDeleteTodo,
                          onEdit: _todoBloc.onUpdateTodoDescription,
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
                              scrollController: _scrollController,
                              todos: todos,
                              onToggle: _todoBloc.onToggleTodo,
                              onDelete: _todoBloc.onDeleteTodo,
                              onEdit: _todoBloc.onUpdateTodoDescription,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              AddTodoWidget(
                onAdd: _todoBloc.onAdd,
              )
            ],
          ),
        ),
      ),
    );
  }
}
