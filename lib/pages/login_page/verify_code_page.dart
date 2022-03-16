import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';

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
    super.initState();
    _textController = TextEditingController(text: _code);
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
          title: Text('enter_code'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PinCodeTextField(
                appContext: context,
                length: 4,
                controller: _textController,
                keyboardType: TextInputType.number,
                hapticFeedbackTypes: HapticFeedbackTypes.vibrate,
                autoDismissKeyboard: true,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 250),
                animationType: AnimationType.slide,
                autoFocus: true,
                enablePinAutofill: true,
                showCursor: false,
                pinTheme: PinTheme(
                  activeColor: AppColors.orange,
                  selectedColor: AppColors.orange,
                  disabledColor: AppColors.defaultGrey,
                  inactiveColor: AppColors.defaultGrey,
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AppButton(
                color: AppColors.lightGrey,
                title: 'send',
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
