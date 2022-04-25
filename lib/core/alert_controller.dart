import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
}
