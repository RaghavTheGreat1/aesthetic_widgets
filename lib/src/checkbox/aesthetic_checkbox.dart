import 'package:flutter/material.dart';

class AestheticCheckbox extends StatefulWidget {
  const AestheticCheckbox({
    super.key,
    this.value,
    this.onChanged,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;

  @override
  State<AestheticCheckbox> createState() => _AestheticCheckboxState();
}

class _AestheticCheckboxState extends State<AestheticCheckbox> {
  late final ValueNotifier<bool?> valueNotifier;

  IconData getIconData(bool? status) {
    IconData icon;
    if (status == true) {
      icon = Icons.check_rounded;
    } else if (status == false) {
      icon = Icons.close_rounded;
    } else {
      icon = Icons.circle;
    }

    return icon;
  }

  @override
  void initState() {
    super.initState();
    valueNotifier = ValueNotifier<bool?>(widget.value);
  }

  @override
  void didUpdateWidget(covariant AestheticCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      valueNotifier.value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: () {
        if (widget.value != null) {
          valueNotifier.value = !valueNotifier.value!;
        }
        widget.onChanged?.call(valueNotifier.value);
      },
      icon: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
        ),
        child: ValueListenableBuilder(
          valueListenable: valueNotifier,
          builder: (context, value, icon) {
            return Icon(
              getIconData(value),
              size: widget.value != null ? 18 : 8,
              color: theme.colorScheme.onPrimary,
            );
          },
        ),
      ),
    );
  }
}
