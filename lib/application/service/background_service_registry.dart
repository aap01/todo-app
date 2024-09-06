import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../di/dependency.dart';
import '../../firebase_options.dart';

abstract final class BackgroundServiceRegistry {
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // initialize hive first
    await Hive.initFlutter();
    await configureDependencies();
  }

  static Future<void> addAll(
    List<(Future, String)> Function(GetIt getIt) param0,
  ) async {
    for (final sync in param0(getIt)) {
      final sendPort = IsolateNameServer.lookupPortByName(sync.$2);
      try {
        await sync.$1;
        debugPrint('syncing success for ${sync.$2}');
        sendPort?.send(true);
      } catch (e) {
        debugPrint('syncing failed for ${sync.$2} ${e.toString()}');
        sendPort?.send(false);
      }
    }
  }
}
