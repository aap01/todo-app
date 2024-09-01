import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserSettings extends Equatable {
  final Locale locale;

  const UserSettings({required this.locale});

  @override
  List<Object?> get props => [locale];

  UserSettings copyWith({
    Locale? locale,
  }) {
    return UserSettings(
      locale: locale ?? this.locale,
    );
  }
}
