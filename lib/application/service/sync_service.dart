import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../di/dependency.dart';
import '../../firebase_options.dart';

class SyncService {
  static Future<void> sync(
    List<Future<void>> Function(GetIt getIt) param0,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // initialize hive first
    await Hive.initFlutter();
    await configureDependencies();
    for (final sync in param0(getIt)) {
      try {
        await sync;
      } catch (e) {
        debugPrint('Database syncing failed ${e.toString()}');
      }
    }
  }
}
