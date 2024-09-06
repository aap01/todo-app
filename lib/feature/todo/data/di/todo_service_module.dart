import 'dart:isolate';

import 'package:injectable/injectable.dart';

import '../../../../application/service/service_port_names.dart';

@module
abstract class TodoServiceModule {
  @lazySingleton
  @Named(ServicePortNames.todo)
  ReceivePort getTodoServicePort() => ReceivePort();
}
