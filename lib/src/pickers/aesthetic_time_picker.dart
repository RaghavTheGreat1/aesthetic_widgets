import 'package:flutter/material.dart';

/// TimePicker chip that shows TimePicker & provides [TimeOfDay] when Time is
/// selected from the picker.
class AestheticTimePicker extends StatefulWidget {
  const AestheticTimePicker({
    Key? key,
    required this.initialTime,
    this.onChanged,
    this.backgroundColor,
    this.borderSide,
  }) : super(key: key);

  final TimeOfDay initialTime;
  final void Function(TimeOfDay selectedTimeOfDay)? onChanged;

  final Color? backgroundColor;
  final BorderSide? borderSide;

  @override
  State<AestheticTimePicker> createState() => _AestheticTimePickerState();
}

class _AestheticTimePickerState extends State<AestheticTimePicker> {
  late ValueNotifier<TimeOfDay> selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = ValueNotifier(widget.initialTime);
  }

  @override
  void didUpdateWidget(covariant AestheticTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTime != widget.initialTime) {
      selectedTime.value = widget.initialTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InputChip(
      backgroundColor: widget.backgroundColor ??
          Theme.of(context).colorScheme.primaryContainer,
      side: widget.borderSide ?? BorderSide.none,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(
            width: 4,
          ),
          ValueListenableBuilder(
            valueListenable: selectedTime,
            builder: (context, time, _) {
              return Text(
                time.format(context),
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              );
            },
          ),
        ],
      ),
      onPressed: () async {
        TimeOfDay time = await showTimePicker(
              context: context,
              initialTime: selectedTime.value,
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

        selectedTime.value = time;

        widget.onChanged?.call(time);
      },
    );
  }
}
