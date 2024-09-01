import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/application/app_widget.dart';
import 'package:todo_app/di/dependency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    Hive.init(null);
  } else {
    Hive.init((await getApplicationDocumentsDirectory()).path);
  }
  await configureDependencies();
  runApp(const AppWidget());
}
