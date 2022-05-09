import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final Color? color;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxConstraints? constraints;

  const AppCard({
    required this.child,
    this.color,
    this.gradient,
    this.padding,
    this.margin,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints ?? const BoxConstraints(minHeight: 24),
      width: MediaQuery.of(context).size.width,
      padding: padding ?? const EdgeInsets.all(8.0),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16.0),
      child: child,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        gradient: gradient,
        color: color ?? (Application.isDarkMode(context) ? AppColors.grey : AppColors.defaultGrey),
      ),
    );
  }
}
