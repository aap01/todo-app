import 'package:injectable/injectable.dart';

import '../entity/user_settings.dart';
import '../repository/user_settings_repository.dart';

@injectable
class UpdateUserSettings {
  final UserSettingsRepository _repository;

  UpdateUserSettings({
    required UserSettingsRepository repository,
  }) : _repository = repository;

  Future<void> call(UserSettings userSettings) =>
      _repository.save(userSettings);
}
