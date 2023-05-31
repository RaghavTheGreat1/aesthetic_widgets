import 'package:flutter/material.dart';

import 'elements/rating_theme.dart';

export 'elements/rating_theme.dart';

class AestheticRatingsPicker extends StatefulWidget {
  const AestheticRatingsPicker({
    super.key,
    required this.count,
    required this.initialIndex,
    required this.ratingTheme,
    required this.onRatingChanged,
    this.fillColor,
    this.borderColor,
  });

  final int count;
  final int initialIndex;
  final ValueChanged<int> onRatingChanged;
  final RatingTheme ratingTheme;

  /// The fill color of the icon when it's liked. Defaults to [ColorScheme.primary]
  final Color? fillColor;

  /// The border color of the icon when it's not liked. Defaults to [ColorScheme.primary]
  final Color? borderColor;

  @override
  State<AestheticRatingsPicker> createState() => _AestheticRatingsPickerState();
}

class _AestheticRatingsPickerState extends State<AestheticRatingsPicker> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();

    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          widget.count,
          (int index) {
            return RatingIcon(
              index: index,
              isLiked: index <= selectedIndex && selectedIndex != -1,
              ratingTheme: widget.ratingTheme,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
                widget.onRatingChanged(selectedIndex);
              },
              fillColor: widget.fillColor,
              borderColor: widget.borderColor,
            );
          },
          growable: false,
        ),
      ],
    );
  }
}

class RatingIcon extends StatefulWidget {
  const RatingIcon({
    Key? key,
    required this.index,
    required this.isLiked,
    required this.onTap,
    required this.ratingTheme,
    this.fillColor,
    this.borderColor,
  }) : super(key: key);

  final int index;
  final bool isLiked;
  final RatingTheme ratingTheme;
  final ValueChanged<int> onTap;

  /// The fill color of the icon when it's liked. Defaults to [ColorScheme.primary]
  final Color? fillColor;

  /// The border color of the icon when it's not liked. Defaults to [ColorScheme.primary]
  final Color? borderColor;

  @override
  State<RatingIcon> createState() => _RatingIconState();
}

class _RatingIconState extends State<RatingIcon> with TickerProviderStateMixin {
  late bool isLiked;

  late AnimationController controller;
  late Animation<double> scale;
  late CurvedAnimation curvedAnimation;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.slowMiddle,
    );
    scale = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(curvedAnimation);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fillColor = (widget.fillColor ?? theme.colorScheme.primary);
    final borderColor = (widget.borderColor ?? theme.colorScheme.onBackground);
    final splashColor = (isLiked ? fillColor : borderColor);
    return SizedBox.square(
      dimension: widget.ratingTheme.size + 16,
      child: ScaleTransition(
        scale: scale,
        child: IconButton(
          splashColor: splashColor,
          onPressed: () {
            setState(() {
              isLiked = !isLiked;
            });
            if (isLiked) {
              controller.forward();
            } else {
              controller.reverse();
            }
            widget.onTap(widget.index);
          },
          icon: Icon(
            widget.isLiked
                ? Icons.favorite_rounded
                : Icons.favorite_outline_rounded,
            size: widget.ratingTheme.size,
            color: fillColor,
          ),
        ),
      ),
    );
  }
}
