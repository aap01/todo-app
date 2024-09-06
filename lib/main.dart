import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/application/app_widget.dart';
import 'package:todo_app/application/service/sync_service.dart';
import 'package:todo_app/di/dependency.dart';
import 'package:todo_app/feature/todo/domain/repository/todo_repository.dart';
import 'package:todo_app/feature/user_settings/domain/repository/user_settings_repository.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:workmanager/workmanager.dart';

// Mandatory if the App is obfuscated or using Flutter 3.1+
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint("Native called background task: $task");
    await SyncService.sync((GetIt getIt) {
      return [
        // add all the repositories that need syncing
        getIt<TodoRepository>().sync(),
        getIt<UserSettingsRepository>().sync(),
      ];
    });
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  if (!kIsWeb) {
    Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          kDebugMode, // If kDebugMode == true, it will post a notification whenever the task is running. Handy for debugging tasks
    );
    await Workmanager().registerPeriodicTask(
      "database-sync", // WARNING: unique identifier, modify with caution. See more: https://github.com/fluttercommunity/flutter_workmanager/blob/main/IOS_SETUP.md
      "simpleTask",
      // this duration does not work for ios, needs to be set in AppDelegate.swift file separately
      frequency: const Duration(hours: 6),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
  await configureDependencies();
  runApp(const AppWidget());
}
