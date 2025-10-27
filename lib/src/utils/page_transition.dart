import 'package:flutter/material.dart';
import 'dart:io';

Route createRoute(
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        customTransition,
    Widget destinationPage) {
  return _CustomPageRoute(
    builder: (context) => destinationPage,
    customTransition: customTransition,
  );
}

class _CustomPageRoute<T> extends PageRoute<T> {
  _CustomPageRoute({
    required this.builder,
    this.customTransition,
    super.settings,
  });

  final WidgetBuilder builder;
  final Widget Function(
          BuildContext, Animation<double>, Animation<double>, Widget)?
      customTransition;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 300);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Widget transitionWidget;

    if (customTransition != null) {
      transitionWidget =
          customTransition!(context, animation, secondaryAnimation, child);
    } else {
      // Default transition
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeOut;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      var slideAnimation = animation.drive(tween);

      var fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      );

      var scaleAnimation = Tween<double>(
        begin: 0.95,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve,
        ),
      );

      transitionWidget = SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        ),
      );
    }

    // Add iOS back gesture support
    if (Platform.isIOS) {
      return const CupertinoPageTransitionsBuilder().buildTransitions<T>(
        this,
        context,
        animation,
        secondaryAnimation,
        transitionWidget,
      );
    }

    return transitionWidget;
  }
}
