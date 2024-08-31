import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@module
abstract class SharedModule {
  @singleton
  Uuid provideUuid() => const Uuid();
}
