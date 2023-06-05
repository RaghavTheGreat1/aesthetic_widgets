import 'package:aesthetic_widgets/aesthetic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../home_screen.dart';

final navigationIndexProvider =
    StateProvider<(int selectedIndex, int hoveredIndex)>((ref) {
  return (0, 0);
});

class AppNavigationRail extends StatefulHookConsumerWidget {
  const AppNavigationRail({
    super.key,
  });

  @override
  ConsumerState<AppNavigationRail> createState() => _AppNavigationRailState();
}

class _AppNavigationRailState extends ConsumerState<AppNavigationRail> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaffoldKey = ref.read(homeScreenScaffoldKeyProvider);

    return AestheticNavigationRail(
      selectedIndex: ref.read(navigationIndexProvider).$1,
      indicatorColor: theme.colorScheme.primary,
      labelType: NavigationRailLabelType.selected,
      selectedIconTheme: IconThemeData(
        color: theme.colorScheme.onPrimary,
      ),
      onDestinationSelected: (value) {
        ref
            .read(navigationIndexProvider.notifier)
            .update((state) => (value, state.$2));
      },
      onDestinationHover: (index, event) {
        ref
            .read(navigationIndexProvider.notifier)
            .update((state) => (state.$1, index));
      },
      onDestinationEnter: (index, event) {
        scaffoldKey.currentState?.openDrawer();
      },
      onDestinationExit: (index, event) {
        scaffoldKey.currentState?.closeDrawer();
      },
      backgroundColor: theme.colorScheme.secondaryContainer,
      destinations: const [
        AestheticNavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          label: Text('Home'),
        ),
        AestheticNavigationRailDestination(
          icon: Icon(Icons.colorize_outlined),
          label: Text('Pickers'),
        ),
      ],
    );
  }
}
