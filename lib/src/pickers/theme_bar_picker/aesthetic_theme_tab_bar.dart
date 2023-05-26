import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class AestheticThemeTabBarPicker extends StatefulWidget {
  const AestheticThemeTabBarPicker({
    Key? key,
    required this.initialThemeMode,
    required this.onChanged,
  }) : super(key: key);

  final ThemeMode initialThemeMode;

  final void Function(ThemeMode selectedThemeMode) onChanged;

  @override
  State<AestheticThemeTabBarPicker> createState() => _AestheticThemeTabBarPickerState();
}

class _AestheticThemeTabBarPickerState extends State<AestheticThemeTabBarPicker>
    with TickerProviderStateMixin {
  late ThemeMode currentThemeMode;
  late TabController controller;

  @override
  void initState() {
    super.initState();

    currentThemeMode = widget.initialThemeMode;
    controller = TabController(
      initialIndex: currentThemeMode.index,
      length: 3,
      animationDuration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 4,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              child: Column(
                children: [
                  TabBar(
                    controller: controller,
                    onTap: (int index) {
                      currentThemeMode = ThemeMode.values[index];

                      controller.animateTo(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.ease,
                      );
                      widget.onChanged(ThemeMode.values[index]);
                    },
                    indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tabs: [
                      _CustomTab(
                        label: 'Device',
                        icon: UniconsLine.mobile_android,
                        isSelected: currentThemeMode == ThemeMode.system,
                      ),
                      _CustomTab(
                        label: 'Light',
                        icon: UniconsLine.sun,
                        isSelected: currentThemeMode == ThemeMode.light,
                      ),
                      _CustomTab(
                        label: 'Dark',
                        icon: UniconsLine.moon,
                        isSelected: currentThemeMode == ThemeMode.dark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTab extends StatelessWidget {
  const _CustomTab({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
  }) : super(key: key);
  final IconData icon;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? Theme.of(context).colorScheme.onSecondaryContainer
                : Theme.of(context).colorScheme.onBackground,
          ),
          const SizedBox(
            width: 1,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onSecondaryContainer
                      : Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ],
      ),
    );
  }
}
