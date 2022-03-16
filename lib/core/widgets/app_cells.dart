import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/app_locales.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/widgets/empty_box.dart';

class InfoCell extends StatelessWidget {
  final String title;
  final String? value;
  final double sizeBetween;
  final double titleSize;
  final FontWeight titleWeight;
  final double valueSize;
  final FontWeight valueWeight;
  final EdgeInsets padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final void Function()? onTap;

  const InfoCell({
    required this.title,
    required this.value,
    this.sizeBetween = 8.0,
    this.titleSize = 15.0,
    this.titleWeight = FontWeight.normal,
    this.valueSize = 16.0,
    this.valueWeight = FontWeight.bold,
    this.padding = const EdgeInsets.all(2.0),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.onTap,
  });

  factory InfoCell.reversed(String title, String value) {
    return InfoCell(title: value, value: title);
  }

  @override
  Widget build(BuildContext context) {
    final _titleStyle = TextStyle(fontSize: titleSize, fontWeight: titleWeight);
    final _valueStyle = TextStyle(fontSize: valueSize, fontWeight: valueWeight);
    return CupertinoButton(
      onPressed: onTap,
      child: Container(
        padding: padding,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Text(title, style: _titleStyle),
            EmptyBox(height: sizeBetween),
            Text(value ?? '-', style: _valueStyle),
          ],
        ),
      ),
    );
  }
}

class ArrowedCell extends StatelessWidget {
  final Widget? icon;
  final String title;
  final Function onTap;
  final Color? color;

  const ArrowedCell({
    required this.title,
    this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => onTap(),
      child: Container(
        constraints: BoxConstraints(minHeight: 24),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Application.isDarkMode(context) ? AppColors.grey : AppColors.defaultGrey,
        ),
        child: Row(
          children: [
            if (icon != null) icon!,
            if (icon != null) EmptyBox(width: 8.0),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(CupertinoIcons.forward),
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchCell extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool) onChanged;
  final Widget? icon;

  const SwitchCell({
    required this.title,
    required this.value,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) icon!,
        if (icon != null) EmptyBox(width: 8),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
        CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          trackColor: Application.isDarkMode(context) ? AppColors.switchOffDark : AppColors.switchOffLight,
          activeColor: Application.isDarkMode(context) ? AppColors.switchOnDark : AppColors.switchOnLight,
        ),
      ],
    );
  }
}

class CountryCell extends StatelessWidget {
  const CountryCell({
    Key? key,
    required this.locale,
    required this.onTap,
    this.backgroundColor,
    this.padding,
    this.isSelected = false,
  }) : super(key: key);

  final Locale locale;
  final void Function() onTap;
  final Color? backgroundColor;
  final bool isSelected;
  final EdgeInsets? padding;

  String _getFlagPath() {
    if (AppLocales.isEng(locale)) return 'assets/flags/en.png';
    if (AppLocales.isRus(locale)) return 'assets/flags/ru.png';
    return 'assets/flags/global.png';
  }

  String _getLanguage() {
    if (AppLocales.isEng(locale)) return 'English';
    if (AppLocales.isRus(locale)) return 'Русский';
    return 'Unkownn';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: isSelected ? Border.all(color: AppColors.defaultGrey) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: padding ?? const EdgeInsets.all(16.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    _getFlagPath(),
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(_getLanguage()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
