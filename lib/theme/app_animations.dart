import 'package:flutter/material.dart';

/// Constantes de animación de la aplicación
class AppAnimations {
  // Duraciones
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);
  
  // Duraciones específicas
  static const Duration spin = Duration(milliseconds: 2000);
  static const Duration cardFlip = Duration(milliseconds: 600);
  static const Duration fadeIn = Duration(milliseconds: 300);
  static const Duration slideIn = Duration(milliseconds: 400);
  
  // Curvas de animación
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elastic = Curves.elasticOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  
  // Curvas específicas para la ruleta
  static const Curve spinCurve = Curves.easeOutCirc;
  static const Curve cardFlipCurve = Curves.easeInOutCubic;
  
  // Delays
  static const Duration delayShort = Duration(milliseconds: 100);
  static const Duration delayNormal = Duration(milliseconds: 200);
  static const Duration delayLong = Duration(milliseconds: 500);
  
  // Transiciones de página
  static Route<T> fadeRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: normal,
    );
  }
  
  static Route<T> slideRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween.chain(
          CurveTween(curve: defaultCurve),
        ));
        
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: normal,
    );
  }
}
