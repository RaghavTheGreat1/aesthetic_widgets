import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/calendar_timeline_provider.dart';

class DaySelector extends ConsumerStatefulWidget {
  const DaySelector({
    super.key,
    this.onDayChanged,
    this.spots,
  });

  final ValueChanged<int>? onDayChanged;
  final Map<DateTime, int>? spots;

  @override
  ConsumerState<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends ConsumerState<DaySelector> {
  late final int selectedDay;
  final today = DateTime.now();

  final scrollController = ScrollController(
    initialScrollOffset: 0,
  );

  @override
  void initState() {
    super.initState();
    selectedDay =
        ref.read(calendarTimelineProvider.select((value) => value.day));
  }

  int maxDaysInMonth(DateTime dateTime) {
    return DateTimeRange(
      start: dateTime,
      end: DateTime(
        dateTime.year,
        dateTime.month + 1,
      ),
    ).duration.inDays;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ref.listen(calendarTimelineProvider.select((value) => value.year),
        (prev, now) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );
    });
    ref.listen(calendarTimelineProvider.select((value) => value.month),
        (prev, now) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );
    });
    return SizedBox(
      height: 70,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Consumer(
          builder: (context, ref, child) {
            final selectedYear = ref
                .watch(calendarTimelineProvider.select((value) => value.year));
            final selectedMonth = ref
                .watch(calendarTimelineProvider.select((value) => value.month));
            final datesCount =
                (today.year == selectedYear && today.month == selectedMonth)
                    ? today.day
                    : maxDaysInMonth(
                        DateTime(selectedYear, selectedMonth),
                      );

            return Row(
              children: List.generate(
                datesCount,
                growable: false,
                (index) {
                  return HookConsumer(
                    builder: (context, ref, _) {
                      final currentDay = (today.year == selectedYear &&
                              today.month == selectedMonth)
                          ? today.day - index
                          : maxDaysInMonth(
                                DateTime(selectedYear, selectedMonth),
                              ) -
                              index;
                      final day = ref.watch(calendarTimelineProvider
                          .select((value) => value.day));

                      final isSelected = day == currentDay;
                      return InkWell(
                        onTap: () {
                          widget.onDayChanged?.call(currentDay);
                        },
                        child: Container(
                          height: 70,
                          width: 56,
                          decoration: BoxDecoration(
                            color: day != currentDay
                                ? theme.colorScheme.background
                                : theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentDay.toString(),
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                          color: day == currentDay
                                              ? Colors.white
                                              : theme.colorScheme.primary),
                                ),
                                if (widget.spots == null)
                                  const SizedBox.shrink()
                                else
                                  Builder(
                                    builder: (context) {
                                      final key = DateTime(
                                        selectedYear,
                                        selectedMonth,
                                        currentDay,
                                      );
                                      final hasSpots =
                                          widget.spots!.containsKey(key);
                                      final spotsCount =
                                          hasSpots ? widget.spots![key]! : 0;
                                      if (spotsCount == 0) {
                                        return const SizedBox.shrink();
                                      }
                                      return SizedBox(
                                        height: 4,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                            spotsCount,
                                            growable: false,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0),
                                              child: CircleAvatar(
                                                radius: 2,
                                                backgroundColor: isSelected
                                                    ? Colors.white
                                                    : theme.colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
