import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder {
  CustomPageRoute({
    required this.child,
    this.direction = AxisDirection.up,
    this.curve = Curves.easeInOut,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          fullscreenDialog: true,
          transitionDuration: const Duration(milliseconds: 250),
        );

  final Widget child;
  final AxisDirection direction;
  final Curve curve;

  Animatable<Offset> _getTween() {
    switch (direction) {
      case AxisDirection.up:
        return Tween(begin: Offset(0, 1), end: Offset.zero).chain(CurveTween(curve: curve));
      case AxisDirection.down:
        return Tween(begin: Offset(0, -1), end: Offset.zero).chain(CurveTween(curve: curve));
      case AxisDirection.left:
        return Tween(begin: Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: curve));
      case AxisDirection.right:
        return Tween(begin: Offset(-1, 0), end: Offset.zero).chain(CurveTween(curve: curve));
      default:
        return Tween(begin: Offset(0.0, 1.0), end: Offset.zero).chain(CurveTween(curve: curve));
    }
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return SlideTransition(
      position: _getTween().animate(animation),
      child: child,
    );
  }
}
