import 'package:flutter/material.dart';

class TabContainer extends StatelessWidget {
  const TabContainer({super.key, required this.child, required this.maxWidth});

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal:
                windowWidth > maxWidth + 36 ? (windowWidth - maxWidth) / 2 : 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0 / 2),
          child: child,
        ),
      ),
    );
  }
}
