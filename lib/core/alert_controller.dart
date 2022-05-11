import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/utils.dart';

import 'application.dart';

class AlertController {
  static void showNativeDialog({
    required BuildContext context,
    required String title,
    String? message,
    String? onYesTitle,
    String? onNoTitle,
    required void Function() onYes,
    required void Function() onNo,
    bool barrierDismissible = false,
  }) async {
    if (Platform.isIOS || Platform.isMacOS) {
      return await showCupertinoDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: message == null || message.isEmpty ? null : Text('\n$message'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(onNoTitle ?? 'no'.tr()),
              onPressed: onNo,
            ),
            CupertinoDialogAction(
              child: Text(onYesTitle ?? 'yes'.tr()),
              onPressed: onYes,
            ),
          ],
        ),
      );
    }
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: message == null || message.isEmpty ? null : Text('\n$message'),
        actions: [
          TextButton(child: Text(onNoTitle ?? 'no'.tr()), onPressed: onNo),
          TextButton(child: Text(onYesTitle ?? 'yes'.tr()), onPressed: onYes),
        ],
      ),
    );
  }

  static void showSimpleDialog({
    required BuildContext context,
    required String message,
    bool barrierDismissible = true,
    void Function()? onPressed,
  }) async {
    if (Platform.isIOS || Platform.isMacOS) {
      return await showCupertinoDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) => CupertinoAlertDialog(
          title: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('done'.tr()),
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => SimpleDialog(
        title: Text(message),
        children: [
          TextButton(
            child: Text('done'.tr()),
            onPressed: onPressed ?? () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  static void showSnackbar({required BuildContext context, required String message}) async {
    if (Utils.isUnauthorizedStatusCode(message)) {
      AlertController.showSimpleDialog(
        context: context,
        message: message,
        barrierDismissible: false,
        onPressed: () => Application.clearStorage(context: context),
      );
    }
    await Flushbar(
      message: message,
      messageText: Text(
        message,
        style: TextStyle(fontSize: 16.0, color: Application.isDarkMode(context) ? AppColors.darkGrey : AppColors.metal),
      ),
      isDismissible: true,
      backgroundColor: Application.isDarkMode(context) ? AppColors.metal : AppColors.darkGrey,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      borderRadius: AppConstraints.borderRadius,
      backgroundGradient: Application.isDarkMode(context)
          ? const LinearGradient(colors: [AppColors.metal, AppColors.snow])
          : const LinearGradient(colors: [AppColors.darkGrey, AppColors.vengence]),
      duration: const Duration(milliseconds: 1600),
      animationDuration: const Duration(milliseconds: 500),
    ).show(context);
  }
}
