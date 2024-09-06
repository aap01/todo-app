import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../repository/user_settings_repository.dart';

@injectable
class UpdateUserSettings {
  final UserSettingsRepository _repository;

  UpdateUserSettings({
    required UserSettingsRepository repository,
  }) : _repository = repository;

  Future<void> call({Locale? locale}) => _repository.save(locale: locale);
}
