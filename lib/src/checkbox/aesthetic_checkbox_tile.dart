import 'package:flutter/material.dart';

import 'aesthetic_checkbox.dart';

export 'aesthetic_checkbox.dart';

class AestheticCheckboxTile extends StatefulWidget {
  const AestheticCheckboxTile({
    super.key,
    this.value,
    required this.title,
    this.onChanged,
  });

  final bool? value;
  final String title;
  final ValueChanged<bool?>? onChanged;

  @override
  State<AestheticCheckboxTile> createState() => _AestheticCheckboxTileState();
}

class _AestheticCheckboxTileState extends State<AestheticCheckboxTile> {
  late final ValueNotifier<bool?> valueNotifier;

  @override
  void initState() {
    super.initState();
    valueNotifier = ValueNotifier<bool?>(widget.value);
  }

  @override
  void didUpdateWidget(covariant AestheticCheckboxTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      valueNotifier.value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onChanged == null
          ? null
          : () {
              if (widget.value != null) {
                valueNotifier.value = !valueNotifier.value!;
              }
              widget.onChanged?.call(valueNotifier.value);
            },
      child: Row(
        children: [
          ValueListenableBuilder(
            valueListenable: valueNotifier,
            builder: (context, value, _) {
              return AestheticCheckbox(
                value: value,
                onChanged: widget.onChanged,
              );
            },
          ),
          Flexible(
            child: Text(widget.title),
          ),
        ],
      ),
    );
  }
}
