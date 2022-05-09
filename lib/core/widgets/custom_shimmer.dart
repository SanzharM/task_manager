import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    Key? key,
    required this.child,
    this.enabled = true,
  }) : super(key: key);

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Shimmer.fromColors(
      child: child,
      enabled: enabled,
      baseColor: Application.isDarkMode(context) ? AppColors.metal : AppColors.vengence,
      highlightColor: Application.isDarkMode(context) ? AppColors.vengence : AppColors.metal,
    );
  }
}
