import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  const AppButton({
    required this.title,
    required this.onTap,
    this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(minHeight: 24.0),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: color,
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: isLoading
            ? Center(child: CircularProgressIndicator.adaptive())
            : Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}
