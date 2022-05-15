import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/app_locales.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
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

  factory InfoCell.task({required String title, required String? value, void Function()? onTap}) {
    return InfoCell(
      title: title,
      value: value,
      crossAxisAlignment: CrossAxisAlignment.start,
      padding: EdgeInsets.zero,
      onTap: onTap ?? () {},
    );
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
  final void Function() onTap;
  final bool needBorder;
  final Color? borderColor;

  const ArrowedCell({
    required this.title,
    this.icon,
    required this.onTap,
    this.needBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: 24),
        width: double.infinity,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: AppConstraints.borderRadius,
          border: needBorder
              ? Border.all(
                  color: borderColor ?? (Application.isDarkMode(context) ? AppColors.snow : AppColors.grey),
                )
              : null,
          color: Application.isDarkMode(context) ? AppColors.grey : AppColors.defaultGrey,
        ),
        child: Row(
          children: [
            const EmptyBox(width: 8.0),
            if (icon != null) icon!,
            if (icon != null) const EmptyBox(width: 8.0),
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
        if (icon != null) const EmptyBox(width: 8),
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
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: isSelected ? Border.all(color: AppColors.defaultGrey) : null,
          borderRadius: AppConstraints.borderRadius,
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
                  borderRadius: AppConstraints.borderRadius,
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

class OneLineCell extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final Widget? icon;
  final Widget? leading;
  final String? header;
  final bool needIcon;
  final double? iconPadding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool needBorder;
  final BoxConstraints? constraints;
  final Color? fillColor;
  final bool centerTitle;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const OneLineCell({
    Key? key,
    required this.title,
    required this.onTap,
    this.icon,
    this.leading,
    this.header,
    this.needIcon = true,
    this.iconPadding,
    this.fontSize,
    this.fontWeight,
    this.needBorder = false,
    this.constraints,
    this.fillColor,
    this.centerTitle = false,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  factory OneLineCell.arrowed({
    required String title,
    required void Function() onTap,
    Widget? leading,
    bool? centerTitle,
    bool needBorder = false,
    EdgeInsets? padding,
  }) {
    return OneLineCell(
      title: title,
      onTap: onTap,
      centerTitle: centerTitle ?? false,
      leading: leading,
      needBorder: needBorder,
      fillColor: Colors.transparent,
      padding: const EdgeInsets.all(8.0),
      icon: const Icon(CupertinoIcons.forward),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      key: key,
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        constraints: constraints,
        padding: padding ?? EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? AppConstraints.borderRadius,
          color: fillColor ?? (Application.isDarkMode(context) ? AppColors.grey : AppColors.white),
          border: needBorder ? Border.all(color: AppColors.defaultGrey) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: leading!,
              ),
            Expanded(
              flex: 3,
              child: SizedBox(
                child: Text(
                  title,
                  textAlign: centerTitle ? TextAlign.center : TextAlign.left,
                  style: TextStyle(
                    fontSize: fontSize ?? 16,
                    fontWeight: fontWeight ?? FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (needIcon)
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: iconPadding ?? 0.0),
                    child: icon ?? const Icon(Icons.more_horiz),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
