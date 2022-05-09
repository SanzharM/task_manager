import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/app_constraints.dart';

class AppBackButton extends StatelessWidget {
  final Function? onBack;
  const AppBackButton({this.onBack});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Icon(CupertinoIcons.back),
      onPressed: () {
        if (onBack != null) {
          onBack!();
          return;
        }
        Navigator.of(context).pop();
      },
    );
  }
}

class AppButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final Color? color;
  final bool isLoading;
  final bool needBorder;
  final double? borderWidth;
  final Color? borderColor;

  const AppButton({
    required this.title,
    required this.onTap,
    this.color,
    this.isLoading = false,
    this.needBorder = false,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(minHeight: 24.0),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: AppConstraints.borderRadius,
        border: needBorder
            ? Border.all(
                color: borderColor ?? (Application.isDarkMode(context) ? AppColors.metal : AppColors.vengence),
                width: borderWidth ?? 0.5,
              )
            : null,
        color: color,
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: isLoading
            ? const SizedBox(
                height: 24.0,
                width: 24.0,
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            : Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}
