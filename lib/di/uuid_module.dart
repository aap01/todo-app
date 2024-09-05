import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@module
abstract class UuidModule {
  Uuid provideUuid() => const Uuid();
}
