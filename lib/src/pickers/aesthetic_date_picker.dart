import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicons/unicons.dart';

/// DateSelector chip that shows DatePicker & provides [DateTime] when Date is
/// selected from the picker.
class AestheticDatePicker extends StatefulWidget {
  const AestheticDatePicker({
    Key? key,
    required this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.backgroundColor,
    this.borderSide,
  }) : super(key: key);

  /// Initial date that should be displayed.
  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  /// [DateTime] callback that provides the [DateTime] selected by the user.
  final void Function(DateTime selectedDate)? onChanged;

  final Color? backgroundColor;
  final BorderSide? borderSide;

  @override
  State<AestheticDatePicker> createState() => _AestheticDatePickerState();
}

class _AestheticDatePickerState extends State<AestheticDatePicker> {
  late final ValueNotifier<DateTime> selectedDateFromPicker;

  @override
  void initState() {
    super.initState();
    selectedDateFromPicker = ValueNotifier(DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    ));
  }

  @override
  void didUpdateWidget(covariant AestheticDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDate != widget.initialDate) {
      selectedDateFromPicker.value = DateTime(
        widget.initialDate.year,
        widget.initialDate.month,
        widget.initialDate.day,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InputChip(
      backgroundColor: widget.backgroundColor ??
          theme.colorScheme.primaryContainer,
      side: widget.borderSide ?? BorderSide.none,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            UniconsLine.calendar_alt,
            size: 16,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(
            width: 4,
          ),
          ValueListenableBuilder(
              valueListenable: selectedDateFromPicker,
              builder: (context, date, _) {
                return Text(
                  DateFormat.yMMMMd('en_US').format(date),
                  style: theme.textTheme.labelLarge!.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                );
              }),
        ],
      ),
      onPressed: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: selectedDateFromPicker.value,
          firstDate: widget.firstDate ??
              selectedDateFromPicker.value
                  .subtract(const Duration(days: 365 * 200)),
          lastDate: widget.lastDate ??
              selectedDateFromPicker.value.add(const Duration(days: 365 * 200)),
          builder: (context, child) {
            return Theme(
              data: theme.copyWith(
                dialogTheme: DialogTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        // Updates the display formatted datetime text when triggered.
        selectedDateFromPicker.value =
            selectedDate ?? selectedDateFromPicker.value;
        print(selectedDateFromPicker.value);
        widget.onChanged?.call(selectedDateFromPicker.value);
      },
    );
  }
}
