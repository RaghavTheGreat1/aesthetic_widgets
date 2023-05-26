import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicons/unicons.dart';

/// DateSelector chip that shows DatePicker & provides [DateTime] when Date is
/// selected from the picker.
class AestheticDatePicker extends StatefulWidget {
  const AestheticDatePicker({
    Key? key,
    required this.initialDate,
    required this.onSelected,
  }) : super(key: key);

  /// Initial date that should be displayed.
  final DateTime initialDate;

  /// [DateTime] callback that provides the [DateTime] selected by the user.
  final void Function(DateTime selectedDate) onSelected;

  @override
  State<AestheticDatePicker> createState() => _AestheticDatePickerState();
}

class _AestheticDatePickerState extends State<AestheticDatePicker> {
  late DateTime selectedDateFromPicker;

  @override
  void initState() {
    super.initState();
    selectedDateFromPicker = widget.initialDate;
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
            DateFormat.yMMMMd('en_US').format(selectedDateFromPicker),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ],
      ),
      onPressed: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: selectedDateFromPicker,
          firstDate: DateTime.now().subtract(const Duration(days: 365 * 200)),
          lastDate: DateTime.now().add(const Duration(days: 365 * 200)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
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
        setState(() {
          // Updates the display formatted datetime text when triggered.
          selectedDateFromPicker = selectedDate ?? selectedDateFromPicker;
        });
        widget.onSelected(selectedDateFromPicker);
      },
    );
  }
}
