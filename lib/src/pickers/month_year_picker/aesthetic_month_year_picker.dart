import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicons/unicons.dart';

import 'show_month_year_picker.dart';

/// MonthYear selector chip that shows Month & Year Picker & provides in form of [DateTime] when Month & Year is
/// selected from the picker.
class AestheticMonthYearPicker extends StatefulWidget {
  const AestheticMonthYearPicker({
    Key? key,
    required this.initialMonthYear,
    required this.onSelected,
  }) : super(key: key);

  /// Initial month & year that needs to be displayed.
  final DateTime initialMonthYear;

  /// [DateTime] callback that provides the [DateTime] selected by the user.
  final void Function(DateTime selectedDate) onSelected;

  @override
  State<AestheticMonthYearPicker> createState() => _AestheticMonthYearPickerState();
}

class _AestheticMonthYearPickerState extends State<AestheticMonthYearPicker> {
  late DateTime selectedMonthYearFromPicker;

  @override
  void initState() {
    super.initState();
    selectedMonthYearFromPicker = widget.initialMonthYear;
  }

  @override
  Widget build(BuildContext context) {
    return InputChip(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            UniconsLine.calendar_alt,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            DateFormat.yMMMM('en_US').format(selectedMonthYearFromPicker),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ],
      ),
      onPressed: () async {
        DateTime? selectedMonthYear = await showMonthYearPicker(
          context: context,
          initialDate: selectedMonthYearFromPicker,
          firstDate: DateTime.now().subtract(const Duration(days: 365 * 200)),
          lastDate: DateTime.now().add(const Duration(days: 365 * 200)),
        );
        setState(() {
          // Updates the display formatted datetime text when triggered.
          selectedMonthYearFromPicker =
              selectedMonthYear ?? selectedMonthYearFromPicker;
        });
        widget.onSelected(selectedMonthYearFromPicker);
      },
    );
  }
}
