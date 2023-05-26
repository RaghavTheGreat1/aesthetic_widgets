import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/calendar_timeline_provider.dart';

class YearSelector extends ConsumerStatefulWidget {
  const YearSelector({
    super.key,
    this.onYearChanged,
  });

  final ValueChanged<int>? onYearChanged;

  @override
  ConsumerState<YearSelector> createState() => _YearSelectorState();
}

class _YearSelectorState extends ConsumerState<YearSelector> {
  late final int selectedYear;
  final today = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedYear =
        ref.read(calendarTimelineProvider.select((value) => value.year));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            int year = ref.read(calendarTimelineProvider).year;
            return AlertDialog(
              title: const Text("Select Year"),
              content: SizedBox(
                width: 300,
                height: 300,
                child: YearPicker(
                  firstDate: DateTime(1979, 1),
                  lastDate: today,
                  selectedDate: DateTime(year),
                  onChanged: (DateTime dateTime) {
                    widget.onYearChanged?.call(dateTime.year);
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        );
      },
      child: HookConsumer(
        builder: (context, ref, _) {
          int year = ref.watch(calendarTimelineProvider).year;
          return Text(
            year.toString(),
            style: theme.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }
}
