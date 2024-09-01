import 'package:injectable/injectable.dart';

import '../entity/user_settings.dart';
import '../repository/user_settings_repository.dart';

@injectable
class GetUserSettings {
  final UserSettingsRepository _repository;

  GetUserSettings({
    required UserSettingsRepository repository,
  }) : _repository = repository;

  Future<UserSettings> call() => _repository.get();
}
