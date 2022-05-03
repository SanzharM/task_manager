import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:easy_localization/easy_localization.dart';

class AppTextField extends StatefulWidget {
  final String? hint;
  final String? label;
  final String? text;
  final String? initialText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isValid;
  final bool loadingIndicator;
  final bool obscureText;
  final bool enabled;
  final bool shouldRequestFocus;
  final bool readonly;
  final bool isOTP;
  final TextCapitalization textCapitalization;
  final int maxLength;
  final int maxLines;
  final bool needValidator;

  final Function(String value)? onChanged;
  final Function onTap;
  final void Function(String)? onSubmit;
  final String? Function(String? value)? validator;

  AppTextField({
    this.hint = '',
    this.label,
    required this.text,
    this.initialText,
    this.isValid = true,
    this.enabled = true,
    this.isOTP = false,
    this.inputFormatters,
    this.maxLength = 300,
    this.maxLines = 1,
    this.loadingIndicator = false,
    this.keyboardType,
    this.shouldRequestFocus = false,
    this.obscureText = false,
    this.readonly = false,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    required this.onTap,
    this.onSubmit,
    this.validator,
    this.needValidator = false,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final focus = FocusNode();

  late Color currentColor;

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) return 'field_cannot_be_empty'.tr();
    return null;
  }

  @override
  void initState() {
    currentColor = AppColors.metal;

    if (!widget.readonly) {
      focus.addListener(_onFocusChange);
      if (widget.shouldRequestFocus) {
        focus.requestFocus();
      }
    }
    super.initState();
  }

  void _onFocusChange() {
    currentColor = focus.hasFocus ? AppColors.snow : AppColors.metal;

    if (focus.hasFocus) {
      widget.onTap();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        widget.readonly ? readonly() : editable(),
        Visibility(
          visible: widget.loadingIndicator,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: CupertinoActivityIndicator(
                animating: widget.loadingIndicator,
                radius: 11,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget editable() {
    String? text = widget.text;

    if ((widget.text == '') && focus.hasFocus) {
      text = widget.initialText ?? '';
    }

    var controller = TextEditingController(text: text);
    final offset = text?.length ?? 0;
    controller.value = controller.value.copyWith(
      text: text,
      selection: TextSelection(baseOffset: offset, extentOffset: offset),
    );
    return Container(
      height: widget.maxLines == 1 ? 54 : null,
      padding: widget.needValidator ? const EdgeInsets.only(top: 8.0, bottom: 8.0) : EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(
          color: Application.isDarkMode(context) ? AppColors.snow.withOpacity(0.3) : AppColors.darkGrey.withOpacity(0.3),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        focusNode: focus,
        readOnly: widget.readonly,
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        controller: controller,
        textCapitalization: widget.textCapitalization,
        autofillHints: widget.isOTP ? [AutofillHints.oneTimeCode] : [],
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.label,
          border: InputBorder.none,
          counterText: '',
          hintStyle: TextStyle(color: AppColors.grey),
          isDense: false,
          contentPadding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        validator: widget.needValidator ? (widget.validator ?? _defaultValidator) : null,
        maxLines: widget.maxLines,
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        onChanged: (val) {
          if (widget.onChanged != null) widget.onChanged!(val);
        },
        onTap: () {
          if (widget.readonly) {
            widget.onTap();
          }
        },
        onFieldSubmitted: (value) {
          if (widget.onSubmit != null) widget.onSubmit!(value);
        },
      ),
    );
  }

  Widget readonly() {
    final hasInitial = widget.text != null ? widget.text!.length > 0 : false;
    final padding = hasInitial ? EdgeInsets.symmetric(vertical: 8, horizontal: 16) : EdgeInsets.symmetric(vertical: 17, horizontal: 16);
    return Container(
      height: widget.maxLines == 1 ? 54 : null,
      decoration: BoxDecoration(
        border: Border.all(
          color: Application.isDarkMode(context) ? AppColors.snow.withOpacity(0.3) : AppColors.darkGrey.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        readOnly: widget.readonly,
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        controller: TextEditingController(text: widget.text),
        textCapitalization: widget.textCapitalization,
        decoration: InputDecoration(
          hintText: hasInitial ? null : widget.label,
          labelText: hasInitial ? widget.label : null,
          border: InputBorder.none,
          counterText: '',
          isDense: true,
          hintStyle: TextStyle(color: Application.isDarkMode(context) ? AppColors.metal : AppColors.grey),
          labelStyle: TextStyle(color: Application.isDarkMode(context) ? AppColors.metal : AppColors.grey),
          contentPadding: padding,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        maxLines: widget.maxLines,
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        onTap: () {
          if (widget.readonly) {
            widget.onTap();
          }
        },
      ),
    );
  }
}
