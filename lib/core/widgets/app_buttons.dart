import 'package:flutter/cupertino.dart';

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
