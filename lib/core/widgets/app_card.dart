import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/app_constraints.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final Color? color;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxConstraints? constraints;
  final Border? border;

  const AppCard({
    required this.child,
    this.color,
    this.gradient,
    this.padding,
    this.margin,
    this.constraints,
    this.border,
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
        borderRadius: AppConstraints.borderRadius,
        border: border,
        gradient: gradient,
        color: color ?? (Application.isDarkMode(context) ? AppColors.grey : AppColors.defaultGrey),
      ),
    );
  }
}
