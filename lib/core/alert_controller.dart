import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertController {
  static void showNativeDialog({
    required BuildContext context,
    required String title,
    required String message,
    String onYesTitle = 'Да',
    String onNoTitle = 'Нет',
    required Function onYes,
    required Function onNo,
    bool barrierDismissible = false,
  }) async {
    if (Platform.isIOS || Platform.isMacOS) {
      return await showCupertinoDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text('\n$message'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(onNoTitle),
              onPressed: () => onNo(),
            ),
            CupertinoDialogAction(
              child: Text(onYesTitle),
              onPressed: () => onYes(),
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
        content: Text(message),
        actions: [
          TextButton(
            child: Text(onNoTitle),
            onPressed: () => onNo(),
          ),
          TextButton(
            child: Text(onYesTitle),
            onPressed: () => onYes(),
          ),
        ],
      ),
    );
  }
}
