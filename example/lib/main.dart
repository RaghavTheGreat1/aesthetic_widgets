import 'package:dynamic_color/dynamic_color.dart';
import 'package:example/theme/dark_theme.dart';
import 'package:example/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'home_screen.dart';
import 'providers/app_preferences_provider.dart';
import 'service/app_initializer_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appInitializerService = AppInitializerService();
  await appInitializerService.init();
  runApp(
    ProviderScope(
      overrides: appInitializerService.overrides,
      child: const MyAestheticWidgetsGalleryApp(),
    ),
  );
}

class MyAestheticWidgetsGalleryApp extends HookConsumerWidget {
  const MyAestheticWidgetsGalleryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appPreferences = ref.watch(appPreferencesProvider);
    return DynamicColorBuilder(
      builder: (light, dark) {
        return MaterialApp(
          title: 'Aesthetic Widget Gallery',
          themeMode: appPreferences.themeMode,
          theme: lightTheme(light),
          darkTheme: darkTheme(dark),
          home: const HomeScreen(),
        );
      },
    );
  }
}
