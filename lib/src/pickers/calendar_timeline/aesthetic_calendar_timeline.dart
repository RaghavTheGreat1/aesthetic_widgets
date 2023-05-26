import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/calendar_timeline_provider.dart';
import 'widgets/day_selector.dart';
import 'widgets/month_selector.dart';
import 'widgets/year_selector.dart';

class AestheticCalendarTimeline extends StatefulWidget {
  const AestheticCalendarTimeline({
    super.key,
    this.onDateTimeChanged,
    this.spots,
  });

  final ValueChanged<DateTime>? onDateTimeChanged;
  final Map<DateTime, int>? spots;

  @override
  State<AestheticCalendarTimeline> createState() => _CalendarTimelineState();
}

class _CalendarTimelineState extends State<AestheticCalendarTimeline> {
  Map<DateTime, int> customizedSpots = <DateTime, int>{};

  @override
  void initState() {
    super.initState();
    customizedSpots = generateSpots(widget.spots ?? {});
  }

  @override
  void didUpdateWidget(covariant AestheticCalendarTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spots != oldWidget.spots) {
      customizedSpots = generateSpots(widget.spots ?? {});
    }
  }

  Map<DateTime, int> generateSpots(Map<DateTime, int> spots) {
    Map<DateTime, int> newSpots = <DateTime, int>{};

    spots.forEach((key, value) {
      final newKey = DateTime(key.year, key.month, key.day);
      newSpots.addAll({newKey: value});
    });
    return newSpots;
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HookConsumer(
              builder: (context, ref, _) {
                return YearSelector(
                  onYearChanged: (year) {
                    ref.read(calendarTimelineProvider.notifier).updateYear(year);
                    widget.onDateTimeChanged
                        ?.call(ref.read(calendarTimelineProvider));
                  },
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            HookConsumer(
              builder: (context, ref, _) {
                return MonthSelector(
                  onMonthChanged: (month) {
                    ref
                        .read(calendarTimelineProvider.notifier)
                        .updateMonth(month);
                    widget.onDateTimeChanged
                        ?.call(ref.read(calendarTimelineProvider));
                  },
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            HookConsumer(
              builder: (context, ref, _) {
                return DaySelector(
                  spots: customizedSpots,
                  onDayChanged: (day) {
                    ref.read(calendarTimelineProvider.notifier).updateDay(day);
                    widget.onDateTimeChanged
                        ?.call(ref.read(calendarTimelineProvider));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
