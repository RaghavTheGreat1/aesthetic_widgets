import 'package:aesthetic_widgets/aesthetic_widgets.dart';
import 'package:flutter/material.dart';

import 'widget_displayer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          WidgetDisplayer(
            title: 'Theme Selector',
            child: AestheticThemeTabBarPicker(
              initialThemeMode: ThemeMode.system,
              onChanged: (ThemeMode selectedThemeMode) {
                debugPrint(selectedThemeMode.name);
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
    );
  }
}
