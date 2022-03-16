import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:easy_localization/easy_localization.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({Key? key, required this.onVerify}) : super(key: key);

  final void Function(String? code) onVerify;

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  String _code = '';
  late TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController(text: _code);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).hasFocus ? FocusScope.of(context).unfocus() : null,
      child: Scaffold(
        appBar: AppBar(
          title: Text('enter_code'.tr()),
          leading: AppBackButton(),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 200),
                child: PinCodeTextField(
                  autoDisposeControllers: true,
                  mainAxisAlignment: MainAxisAlignment.center,
                  appContext: context,
                  length: 4,
                  controller: _textController,
                  keyboardType: TextInputType.number,
                  hapticFeedbackTypes: HapticFeedbackTypes.vibrate,
                  autoDismissKeyboard: true,
                  animationCurve: Curves.easeInOut,
                  animationDuration: const Duration(milliseconds: 250),
                  animationType: AnimationType.slide,
                  autoFocus: !kIsWeb,
                  enablePinAutofill: true,
                  showCursor: false,
                  pinTheme: PinTheme(
                    activeColor: AppColors.orange,
                    selectedColor: AppColors.orange,
                    disabledColor: AppColors.defaultGrey,
                    inactiveColor: AppColors.defaultGrey,
                    fieldOuterPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onChanged: (value) {
                    _code = value;
                    if (_code.length == 4) widget.onVerify(_code);
                  },
                  onTap: () => setState(() {}),
                  onSubmitted: (value) {
                    if (_code.length == 4) widget.onVerify(_code);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AppButton(
                color: AppColors.lightGrey,
                title: 'send'.tr(),
                onTap: () {
                  if (_code.length == 4) widget.onVerify(_code);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
