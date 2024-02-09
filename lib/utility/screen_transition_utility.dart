import 'package:flutter/material.dart';

class ScreenTransition {
  final Widget page;
  final BuildContext context;
  ScreenTransition(
    this.context,
    this.page,
  );
  void top({VoidCallback? onThen}) {
    Navigator.of(context)
        .push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const Offset begin = Offset(0, 1.0);
              const Offset end = Offset.zero;
              final Animatable<Offset> tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: Curves.easeInOut));
              final Animation<Offset> offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 100),
            reverseTransitionDuration: const Duration(milliseconds: 100),
          ),
        )
        .then((value) => onThen?.call());
  }

  void hero() {
    Navigator.push<Widget>(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 100),
        reverseTransitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (_, __, ___) => page,
      ),
    );
  }

  void normal() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  }

  void left() {
    Navigator.of(context).push<Widget>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return page;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const Offset begin = Offset(-1.0, 0.0);
          const Offset end = Offset.zero;
          final Animatable<Offset> tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          final Animation<Offset> offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}

void screenTransitionReset(BuildContext context) =>
    Navigator.of(context).popUntil(ModalRoute.withName("/"));
