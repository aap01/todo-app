import 'dart:isolate';

import 'package:injectable/injectable.dart';

import '../../../../application/service/service_port_names.dart';

@module
abstract class UserSettingsServiceModule {
  @lazySingleton
  @Named(ServicePortNames.userSettings)
  ReceivePort getUserSettingsServicePort() => ReceivePort();
}
