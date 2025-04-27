import 'package:flutter/material.dart';

class AppAnimations {
  static const Curve standardCurve = Curves.easeInOutCubic;
  static const Curve emphasisCurve = Curves.easeOutCirc;
  static const Curve sharpCurve = Curves.fastOutSlowIn;

  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 400);

  static FadeTransition fade({
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  static SlideTransition slide({
    required Animation<Offset> animation,
    required Widget child,
  }) {
    return SlideTransition(
      position: animation,
      child: child,
    );
  }

  static ScaleTransition scale({
    required Animation<double> animation,
    required Widget child,
    Curve curve = Curves.linear,
  }) {
    return ScaleTransition(
      scale: animation.drive(CurveTween(curve: curve)),
      child: child,
    );
  }

  static Widget like({
    required AnimationController controller,
    required Widget child,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.5)
          .chain(CurveTween(curve: Curves.elasticOut))
          .animate(controller),
      child: child,
    );
  }

  static Widget hover({
    required AnimationController controller,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final offsetAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -5),
        ).animate(controller);
        return Transform.translate(
          offset: offsetAnimation.value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget refresh({
    required AnimationController controller,
    required Widget child,
  }) {
    return RotationTransition(
      turns: Tween<double>(begin: 0, end: 1).animate(controller),
      child: child,
    );
  }
}
