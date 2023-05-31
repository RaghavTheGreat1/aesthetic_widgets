import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_preferences.dart';
import '../providers/app_preferences_provider.dart';

class AppInitializerService {
  List<Override> overrides = [];

  late final SharedPreferences sharedPrefs;
  Future<void> init() async {
    sharedPrefs = await SharedPreferences.getInstance();
    await initializeAppPrefs();
  }

  Future initializeAppPrefs() async {
    final appPreferencesJson = sharedPrefs.getString('appPreferences');
    if (appPreferencesJson != null) {
      final appPreferences = AppPreferences.fromJson(appPreferencesJson);
      overrides.add(
        StateNotifierProvider<AppPreferencesProvider, AppPreferences>((ref) {
          return AppPreferencesProvider(appPreferences);
        }),
      );
    }
  }
}
