import 'package:flutter/material.dart';

class AestheticAnimatedLikeButton extends StatefulWidget {
  const AestheticAnimatedLikeButton({
    super.key,
    this.iconSize,
    this.fillColor = Colors.red,
    this.borderColor = Colors.black,
    required this.onChanged,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
  });

  final double? iconSize;

  /// The fill color of the icon when it's liked. Defaults to [ColorScheme.primary]
  final Color? fillColor;

  /// The border color of the icon when it's not liked. Defaults to [ColorScheme.primary]
  final Color? borderColor;

  final ValueChanged<bool>? onChanged;

  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;

  @override
  State<AestheticAnimatedLikeButton> createState() =>
      _AestheticAnimatedLikeButtonState();
}

class _AestheticAnimatedLikeButtonState
    extends State<AestheticAnimatedLikeButton> with TickerProviderStateMixin {
  bool isLiked = false;
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> curve;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    curve = CurvedAnimation(parent: controller, curve: Curves.slowMiddle);

    scale = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(curve);
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
    final borderColor = (widget.borderColor ?? fillColor);
    final splashColor = (isLiked ? fillColor : borderColor);
    return IconButton(
      highlightColor: widget.highlightColor ?? splashColor.withOpacity(0.2),
      splashColor: widget.splashColor ?? splashColor.withOpacity(0.1),
      hoverColor: widget.hoverColor ?? splashColor.withOpacity(0.1),
      enableFeedback: true,
      icon: ScaleTransition(
        scale: scale,
        child: Icon(
          isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
          size: widget.iconSize ?? 24,
          color: isLiked ? fillColor : borderColor,
        ),
      ),
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });

        if (isLiked) {
          controller.forward();
        } else {
          controller.reverse();
        }

        widget.onChanged?.call(isLiked);
      },
    );
  }
}
