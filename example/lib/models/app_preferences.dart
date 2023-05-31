// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class AppPreferences {
  const AppPreferences({
    required this.themeMode,
    required this.locale,
  });

  final ThemeMode themeMode;
  final Locale locale;

  AppPreferences copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return AppPreferences(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'themeMode': themeMode.name,
      'locale': locale.languageCode,
    };
  }

  factory AppPreferences.fromMap(Map<String, dynamic> map) {
    return AppPreferences(
      themeMode: ThemeMode.values
          .singleWhere((element) => map['themeMode'] == element.name),
      locale: Locale.fromSubtags(
        languageCode: map['locale'] as String,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppPreferences.fromJson(String source) =>
      AppPreferences.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AppUserPreferences(themeMode: $themeMode, locale: $locale)';

  @override
  bool operator ==(covariant AppPreferences other) {
    if (identical(this, other)) return true;

    return other.themeMode == themeMode && other.locale == locale;
  }

  @override
  int get hashCode => themeMode.hashCode ^ locale.hashCode;
}
