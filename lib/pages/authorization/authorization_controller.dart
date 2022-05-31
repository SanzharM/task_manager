import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/supporting/app_router.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/pages/pin_page/pin_page.dart';
import 'package:task_manager/pages/voice_authentication/voice_authentication_page.dart';

enum AuthType { pin, voice }

class AuthController extends StatefulWidget {
  const AuthController({
    Key? key,
    this.authOrder = const [AuthType.pin, AuthType.voice],
    this.shouldSetupPin = false,
    this.shouldSetupVoice = false,
  }) : super(key: key);

  final List<AuthType> authOrder;
  final bool shouldSetupPin;
  final bool shouldSetupVoice;

  @override
  State<AuthController> createState() => _AuthControllerState();
}

class _AuthControllerState extends State<AuthController> {
  late List<AuthType> _authOrder;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _authOrder = widget.authOrder;
    if (_authOrder.isEmpty) {
      return Navigator.of(context).pop();
    }
  }

  void _onBack() {
    if (currentIndex == 0) {
      AlertController.showNativeDialog(
        context: context,
        title: 'confirm_logout'.tr(),
        onYes: () => Application.logout(context),
        onNo: () => Navigator.of(context).pop(),
      );
      return;
    }

    return setState(() => currentIndex -= 1);
  }

  void _onNext() {
    if (currentIndex >= 0 && currentIndex + 1 < _authOrder.length) {
      return setState(() => currentIndex += 1);
    }
    return AppRouter.toMainPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex > 0) {
          setState(() => currentIndex -= 1);
          return false;
        }
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          leading: AppBackButton(onBack: _onBack),
        ),
        body: Builder(
          builder: (context) {
            switch (_authOrder[currentIndex]) {
              case AuthType.pin:
                return PinPage(
                  shouldSetupPin: widget.shouldSetupPin,
                  needAppBar: false,
                  onNext: _onNext,
                );
              case AuthType.voice:
                return VoiceAuthenticationPage(
                  needAppBar: false,
                  onNext: _onNext,
                  mode: widget.shouldSetupVoice ? AuthMode.register : AuthMode.login,
                );
            }
          },
        ),
      ),
    );
  }
}
