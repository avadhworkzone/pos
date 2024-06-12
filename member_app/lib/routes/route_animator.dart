import 'package:flutter/material.dart';

class RouteAnimator extends PageRouteBuilder {
  final Widget page;

  RouteAnimator({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 750),
          reverseTransitionDuration: const Duration(milliseconds: 750),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
