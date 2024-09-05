// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_firestore_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettingsFirestoreModel _$UserSettingsFirestoreModelFromJson(
        Map<String, dynamic> json) =>
    UserSettingsFirestoreModel(
      locale: json['locale'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserSettingsFirestoreModelToJson(
        UserSettingsFirestoreModel instance) =>
    <String, dynamic>{
      'locale': instance.locale,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
