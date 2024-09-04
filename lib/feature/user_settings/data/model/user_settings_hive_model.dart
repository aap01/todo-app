import 'package:hive/hive.dart';

part 'user_settings_hive_model.g.dart';

@HiveType(typeId: 1)
class UserSettingsHiveModel {
  @HiveField(0)
  final String locale;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final DateTime updatedAt;

  UserSettingsHiveModel({
    required this.locale,
    required this.createdAt,
    required this.updatedAt,
  });
}
