import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:todo_app/feature/todo/presentation/todos_container_widget.dart';
import 'package:todo_app/feature/user_settings/presentation/locale_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      ),
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language),
                      const Gap(8),
                      Text(AppLocalizations.of(context)!.language),
                    ],
                  ),
                  BlocBuilder<LocaleBloc, LocaleState>(
                      builder: (context, state) {
                    return LocaleToggleWidget(
                      locale: state.locale,
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ScreenTypeLayout.builder(
          mobile: (_) => const TodosContainerWidget(),
          desktop: (_) => const Center(
            child: SizedBox(
              width: 800,
              child: TodosContainerWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
