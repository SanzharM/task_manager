import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final Color? color;
  const AppCard({required this.child, this.color, this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 24),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      child: child,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        gradient: gradient,
        color: color ??
            (Application.isDarkMode(context)
                ? AppColors.grey
                : AppColors.defaultGrey),
      ),
    );
  }
}
