import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'dependency.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() => getIt.init();
