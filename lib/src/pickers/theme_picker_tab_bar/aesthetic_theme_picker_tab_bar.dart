import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class AestheticThemePickerTabBar extends StatefulWidget {
  const AestheticThemePickerTabBar({
    Key? key,
    required this.initialThemeMode,
    required this.onChanged,
    this.containerBorder,
    this.indicatorBorder,
    this.containerBorderRadius,
    this.indicatorBorderRadius,
  }) : super(key: key);

  final ThemeMode initialThemeMode;

  final void Function(ThemeMode selectedThemeMode) onChanged;

  final Border? containerBorder;
  final Border? indicatorBorder;

  final BorderRadiusGeometry? containerBorderRadius;
  final BorderRadiusGeometry? indicatorBorderRadius;

  @override
  State<AestheticThemePickerTabBar> createState() =>
      _AestheticThemePickerTabBarState();
}

class _AestheticThemePickerTabBarState extends State<AestheticThemePickerTabBar>
    with TickerProviderStateMixin {
  late ThemeMode currentThemeMode;
  late TabController controller;

  final borderRadius = BorderRadius.circular(12);

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
  void didUpdateWidget(covariant AestheticThemePickerTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialThemeMode != widget.initialThemeMode) {
      controller.animateTo(widget.initialThemeMode.index);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                color: theme.colorScheme.background,
                borderRadius: widget.containerBorderRadius ?? borderRadius,
                border: widget.containerBorder,
              ),
              child: TabBar(
                splashBorderRadius: borderRadius,
                dividerColor: Colors.transparent,
                indicatorWeight: 0,
                controller: controller,
                indicatorSize: TabBarIndicatorSize.tab,
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
                  color: theme.colorScheme.primaryContainer,
                  border: widget.indicatorBorder,
                  borderRadius: widget.indicatorBorderRadius ?? borderRadius,
                ),
                tabs: [
                  _CustomTab(
                    label: 'Device',
                    icon: UniconsLine.mobile_android,
                    isSelected: currentThemeMode == ThemeMode.system,
                  ),
                  _CustomTab(
                    label: 'Light',
                    icon: Icons.light_mode_outlined,
                    isSelected: currentThemeMode == ThemeMode.light,
                  ),
                  _CustomTab(
                    label: 'Dark',
                    icon: Icons.dark_mode_outlined,
                    isSelected: currentThemeMode == ThemeMode.dark,
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
    final theme = Theme.of(context);
    return Tab(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onBackground,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            label,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
