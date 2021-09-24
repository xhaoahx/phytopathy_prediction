import 'dart:ui';

import 'package:flutter/material.dart';

const _kTransDuration = const Duration(milliseconds: 600);

class FadeInPageRoute<T> extends PageRoute<T> {
  FadeInPageRoute({
    required this.builder,
    this.duration,
  });

  final WidgetBuilder builder;

  @override
  Duration get transitionDuration => duration ?? _kTransDuration;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  bool get opaque => false;

  @override
  String get barrierLabel => 'FadeInPageRoute';

  @override
  bool get barrierDismissible => true;

  @override
  bool get maintainState => true;


  final Duration? duration;


  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final Animation<double> curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(0.4, 1.0, curve: Curves.easeInToLinear),
    );

    final Tween<double> scaleTween = Tween(
      begin: 2.3,
      end: 1.0,
    );

    final Tween<double> opacityTween = Tween(
      begin: 0.0,
      end: 1.0,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: scaleTween.evaluate(
            animation,
          ),
          child: Opacity(
            opacity: opacityTween.evaluate(
              curvedAnimation,
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
