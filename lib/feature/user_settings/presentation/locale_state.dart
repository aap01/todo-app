import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LocaleState extends Equatable {}

class LocaleStateInitial extends LocaleState {
  @override
  List<Object?> get props => [];
}

class LocaleStateLoaded extends LocaleState {
  final Locale locale;

  LocaleStateLoaded({
    required this.locale,
  });

  @override
  List<Object?> get props => [locale];
}
