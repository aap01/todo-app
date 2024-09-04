import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserSettings extends Equatable {
  final Locale locale;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserSettings({
    required this.locale,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        createdAt,
        updatedAt,
        locale,
      ];

  UserSettings copyWith({
    Locale? locale,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      locale: locale ?? this.locale,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UserSettings.defaultSettings() => UserSettings(
        locale: const Locale('en'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  UserSettings updateLocale(Locale locale) => copyWith(
        locale: locale,
        updatedAt: DateTime.now(),
      );
}
