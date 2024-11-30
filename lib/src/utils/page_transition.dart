import 'package:flutter/material.dart';

Route createRoute(
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        mediaPickerTransition,
    Widget destinationPage) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) => destinationPage,
    transitionsBuilder: mediaPickerTransition ??
        (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Start off-screen to the right
          const end = Offset.zero; // End at screen position
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
  );
}
