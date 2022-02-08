import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/widgets/empty_box.dart';

class PinNumber extends StatelessWidget {
  final String number;
  final Function onTap;
  PinNumber({required this.number, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (number.isEmpty) return const EmptyBox(width: 56, height: 56);

    Widget child = Text(number, style: const TextStyle(fontSize: 28));
    if (number == 'backspace') {
      child = const SizedBox(
        width: 24,
        child: Icon(CupertinoIcons.delete_left_fill),
      );
    }
    return CupertinoButton(
      padding: const EdgeInsets.all(16.0),
      child: child,
      onPressed: () => onTap(),
    );
  }
}

class PinDots extends StatelessWidget {
  final int length;
  final String pin;
  PinDots({required this.length, required this.pin});

  @override
  Widget build(BuildContext context) {
    List<Widget> dots = [];
    for (int i = 0; i < length; i++) {
      dots.add(
        Container(
          constraints: BoxConstraints(minWidth: 14, minHeight: 14),
          decoration: BoxDecoration(
            color: pin.length > i ? AppColors.darkGrey : AppColors.transparent,
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: AppColors.darkGrey),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: dots,
    );
  }
}

class PinNumbers extends StatelessWidget {
  final Function(String) onPressed;
  final Function onDelete;
  final double spaceBetween;

  PinNumbers({
    required this.onPressed,
    required this.onDelete,
    this.spaceBetween = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PinNumber(number: '1', onTap: () => onPressed('1')),
            PinNumber(number: '2', onTap: () => onPressed('2')),
            PinNumber(number: '3', onTap: () => onPressed('3')),
          ],
        ),
        EmptyBox(height: spaceBetween),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PinNumber(number: '4', onTap: () => onPressed('4')),
            PinNumber(number: '5', onTap: () => onPressed('5')),
            PinNumber(number: '6', onTap: () => onPressed('6')),
          ],
        ),
        EmptyBox(height: spaceBetween),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PinNumber(number: '7', onTap: () => onPressed('7')),
            PinNumber(number: '8', onTap: () => onPressed('8')),
            PinNumber(number: '9', onTap: () => onPressed('9')),
          ],
        ),
        EmptyBox(height: spaceBetween),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PinNumber(number: '', onTap: () => null),
            PinNumber(number: '0', onTap: () => onPressed('0')),
            PinNumber(number: 'backspace', onTap: () => onDelete()),
          ],
        ),
      ],
    );
  }
}
