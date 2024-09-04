import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../di/dependency.dart';
import '../../firebase_options.dart';

class SyncService {
  static Future<void> sync(
    List<Future<void>> Function(GetIt getIt) param0,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Hive.init((await getApplicationDocumentsDirectory()).path);
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
