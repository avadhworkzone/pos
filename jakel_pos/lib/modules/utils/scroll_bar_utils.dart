import 'package:flutter/material.dart';

class CustomScrollController extends StatelessWidget {
  final Widget child;

  CustomScrollController({
    super.key,
    required this.child,
  });

  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController verticalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: verticalScrollController,
      thumbVisibility: true,
      child: Scrollbar(
        controller: horizontalScrollController,
        thumbVisibility: true,
        notificationPredicate: (notif) => notif.depth == 1,
        child: SingleChildScrollView(
          controller: verticalScrollController,
          child: SingleChildScrollView(
            controller: horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: child,
          ),
        ),
      ),
    );
  }
}
