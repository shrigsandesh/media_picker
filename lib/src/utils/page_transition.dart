import 'package:flutter/material.dart';

Route createRoute(
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        customTransition,
    Widget destinationPage) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => destinationPage,
    transitionsBuilder: customTransition ??
        (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0); // Start from bottom
          const end = Offset.zero;
          const curve = Curves.easeOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          // Create slide animation
          var slideAnimation = animation.drive(tween);

          // Add fade animation
          var fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
            ),
          );

          // Add scale animation
          var scaleAnimation = Tween<double>(
            begin: 0.95,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: curve,
            ),
          );

          return Container(
            color: Colors.black.withValues(alpha: animation.value * 0.5),
            child: SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: child,
                ),
              ),
            ),
          );
        },
  );
}
