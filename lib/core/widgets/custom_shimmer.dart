import 'dart:math';

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

  static const _colors = [
    AppColors.lightAction,
    AppColors.lightBlue,
    AppColors.success,
    AppColors.switchOnLight,
    AppColors.switchOnDark,
  ];

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    final index = Random.secure().nextInt(_colors.length);
    return Shimmer.fromColors(
      child: child,
      enabled: enabled,
      baseColor: Application.isDarkMode(context) ? AppColors.metal : _colors[index],
      highlightColor: Application.isDarkMode(context) ? _colors[index] : AppColors.metal,
    );
  }
}
