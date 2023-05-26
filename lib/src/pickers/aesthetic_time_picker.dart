import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

/// TimePicker chip that shows TimePicker & provides [TimeOfDay] when Time is
/// selected from the picker.
class AestheticTimePicker extends StatefulWidget {
  const AestheticTimePicker({
    Key? key,
    required this.initialTime,
    required this.onSelected,
  }) : super(key: key);

  final TimeOfDay initialTime;
  final void Function(TimeOfDay selectedTimeOfDay) onSelected;

  @override
  State<AestheticTimePicker> createState() => _AestheticTimePickerState();
}

class _AestheticTimePickerState extends State<AestheticTimePicker> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return InputChip(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            UniconsLine.clock,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            selectedTime.format(context),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ],
      ),
      onPressed: () async {
        TimeOfDay time = await showTimePicker(
              context: context,
              initialTime: selectedTime,
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
            ) ??
            widget.initialTime;
        setState(() {
          selectedTime = time;
        });
        widget.onSelected(time);
      },
    );
  }
}
