import 'package:flutter/material.dart';

class WidgetDisplayer extends StatelessWidget {
  const WidgetDisplayer({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            child
          ],
        ),
      ),
    );
  }
}
