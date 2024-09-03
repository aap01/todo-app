import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/application/app_widget.dart';
import 'package:todo_app/di/dependency.dart';
import 'package:todo_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kIsWeb) {
    Hive.init(null);
  } else {
    Hive.init((await getApplicationDocumentsDirectory()).path);
  }
  await configureDependencies();
  runApp(const AppWidget());
}
