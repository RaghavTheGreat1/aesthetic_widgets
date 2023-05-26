import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/calendar_timeline_provider.dart';

class MonthSelector extends ConsumerStatefulWidget {
  const MonthSelector({
    super.key,
    this.onMonthChanged,
  });

  final ValueChanged<int>? onMonthChanged;

  @override
  ConsumerState<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends ConsumerState<MonthSelector> {
  late final int selectedMonth;
  final today = DateTime.now();

  final scrollController = ScrollController(
    initialScrollOffset: 0,
  );

  @override
  void initState() {
    super.initState();
    selectedMonth =
        ref.read(calendarTimelineProvider.select((value) => value.month));
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

    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Consumer(
          builder: (context, ref, child) {
            final monthsCount =
                today.year == ref.watch(calendarTimelineProvider).year
                    ? today.month
                    : 12;
            return Row(
              children: List.generate(
                monthsCount,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      final month =
                          today.year == ref.read(calendarTimelineProvider).year
                              ? today.month - index
                              : 12 - index;

                      widget.onMonthChanged?.call(month);
                    },
                    child: Row(
                      children: [
                        HookConsumer(
                          builder: (context, ref, _) {
                            final selectedYear = ref.watch(
                                calendarTimelineProvider
                                    .select((value) => value.year));
                            final currentMonth = DateTime(
                              selectedYear,
                              today.year == selectedYear
                                  ? today.month - index
                                  : 12 - index,
                            );
                            final monthName =
                                DateFormat('MMMM').format(currentMonth);
                            return Text(
                              monthName,
                              style: theme.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodyLarge?.color
                                    ?.withOpacity(ref.watch(
                                                calendarTimelineProvider.select(
                                                    (value) => value.month)) ==
                                            currentMonth.month
                                        ? 1
                                        : 0.3),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
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
