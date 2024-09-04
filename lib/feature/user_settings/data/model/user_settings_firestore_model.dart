import 'package:json_annotation/json_annotation.dart';
part 'user_settings_firestore_model.g.dart';

@JsonSerializable()
class UserSettingsFirestoreModel {
  final String locale;

  final DateTime createdAt;

  final DateTime updatedAt;

  UserSettingsFirestoreModel({
    required this.locale,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserSettingsFirestoreModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFirestoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingsFirestoreModelToJson(this);
}
