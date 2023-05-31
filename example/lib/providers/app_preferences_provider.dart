import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_preferences.dart';

final appPreferencesProvider =
    StateNotifierProvider<AppPreferencesProvider, AppPreferences>((ref) {
  return AppPreferencesProvider(const AppPreferences(
    themeMode: ThemeMode.system,
    locale: Locale('en'),
  ));
});

class AppPreferencesProvider extends StateNotifier<AppPreferences> {
  AppPreferencesProvider(AppPreferences appUserPreferences)
      : super(appUserPreferences);

  Future<void> updateThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString('appPreferences', state.toJson());
  }

  Future<void> updateLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString('appPreferences', state.toJson());
  }

  Future<void> reset() async {
    state = const AppPreferences(
      themeMode: ThemeMode.system,
      locale: Locale('en'),
    );
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString('appPreferences', state.toJson());
  }
}
