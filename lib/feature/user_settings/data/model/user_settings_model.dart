import 'package:hive/hive.dart';

part 'user_settings_model.g.dart';

@HiveType(typeId: 1)
class UserSettingsModel {
  @HiveField(0)
  final String locale;

  UserSettingsModel({required this.locale});
}
