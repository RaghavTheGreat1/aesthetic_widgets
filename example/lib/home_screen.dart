import 'package:aesthetic_widgets/aesthetic_widgets.dart';
import 'package:example/providers/app_preferences_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widget_displayer.dart';
import 'widgets/app_navigation_rail.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({
    super.key,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        AppNavigationRail(
          scaffoldKey: scaffoldKey,
        ),
        Flexible(
          child: Scaffold(
            key: scaffoldKey,
            drawerDragStartBehavior: DragStartBehavior.start,
            drawerEnableOpenDragGesture: false,
            drawer: HookConsumer(builder: (context, ref, _) {
              final hoveredIndex = ref
                  .watch(navigationIndexProvider.select((value) => value.$2));
              return Drawer(
                backgroundColor: theme.colorScheme.secondaryContainer,
                child: Text(hoveredIndex.toString()),
              );
            }),
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                WidgetDisplayer(
                  title: 'Theme Selector',
                  child: AestheticThemeTabBarPicker(
                    initialThemeMode: ref.read(appPreferencesProvider
                        .select((value) => value.themeMode)),
                    onChanged: (ThemeMode selectedThemeMode) async {
                      await ref
                          .read(appPreferencesProvider.notifier)
                          .updateThemeMode(selectedThemeMode);
                    },
                  ),
                ),
                WidgetDisplayer(
                  title: 'Date Picker',
                  child: AestheticDatePicker(
                    initialDate: DateTime.now(),
                    onChanged: (DateTime selectedDate) {
                      debugPrint(selectedDate.toString());
                    },
                  ),
                ),
                WidgetDisplayer(
                  title: 'Time Picker',
                  child: AestheticTimePicker(
                    initialTime: TimeOfDay.now(),
                    onChanged: (TimeOfDay selectedTime) {
                      debugPrint(selectedTime.toString());
                    },
                  ),
                ),
                WidgetDisplayer(
                  title: 'Month Picker',
                  child: AestheticMonthYearPicker(
                    initialMonthYear: DateTime.now(),
                    onSelected: (DateTime selectedMonthYear) {
                      debugPrint(selectedMonthYear.toString());
                    },
                  ),
                ),
                WidgetDisplayer(
                  title: 'Animated Like',
                  child: AestheticAnimatedLikeButton(
                    onChanged: (bool isLiked) {
                      debugPrint(isLiked.toString());
                    },
                  ),
                ),
                WidgetDisplayer(
                  title: 'Currency Picker',
                  child: AestheticCurrencyPicker(
                    initialCurrency: Currency.inr(),
                    onSelected: (Currency selectedCountry) {
                      debugPrint(selectedCountry.name);
                    },
                  ),
                ),
                WidgetDisplayer(
                  title: 'Rating Picker',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: AestheticRatingsPicker(
                          count: 5,
                          initialIndex: -1,
                          ratingTheme: RatingTheme(
                            color: Colors.black,
                            size: 24,
                          ),
                          onRatingChanged: (int rating) {
                            debugPrint(rating.toString());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const WidgetDisplayer(
                  title: 'Calendar Timeline',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: AestheticCalendarTimeline(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
