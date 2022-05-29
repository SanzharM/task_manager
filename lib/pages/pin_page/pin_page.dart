import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/app_icons.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/supporting/app_router.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/shake_widget.dart';
import 'package:task_manager/pages/pin_page/pin_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/pages/voice_authentication/voice_authentication_page.dart';

class PinPage extends StatefulWidget {
  final bool shouldSetupPin;
  const PinPage({Key? key, this.shouldSetupPin = false}) : super(key: key);

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> with TickerProviderStateMixin {
  final _shakeKey = GlobalKey<ShakeWidgetState>();

  final _localAuth = LocalAuthentication();
  String _tempPin = '';
  String _pin = '';

  bool hasTouchId = false;
  bool hasFaceId = false;
  bool hasVoice = false;

  String _currentMessage = 'setup_pin_code'.tr();

  bool isLoading = false;

  int _incorrectAttempts = 0;

  static const _duration = const Duration(milliseconds: 50);
  late AnimationController _contoller1;
  late Animation<Offset> _animation1;
  late AnimationController _contoller2;
  late Animation<Offset> _animation2;
  late AnimationController _contoller3;
  late Animation<Offset> _animation3;
  late AnimationController _contoller4;
  late Animation<Offset> _animation4;

  void _controllerListener(AnimationController controller) {
    if (controller.isCompleted) Future.delayed(const Duration(milliseconds: 1), () => controller.reverse());
  }

  void _toMainPage() => AppRouter.toMainPage(context);

  Future<void> _tryLoginWithBiometrics() async {
    try {
      bool didAuthenticate = await _localAuth.authenticate(localizedReason: 'please_authorize'.tr());
      if (didAuthenticate) {
        if (await Application.getWrongVoiceAttempts() > 3) Application.setWrongVoiceAttempts(0);
        _toMainPage();
      }
    } catch (e) {
      print('Unable to local auth. Error: $e');
    }
  }

  void _checkBiometrics() async {
    if (await _localAuth.isDeviceSupported()) {
      final _biometrics = await _localAuth.getAvailableBiometrics();
      final bool biometrics = await Application.useBiometrics();
      if (biometrics && _biometrics.contains(BiometricType.fingerprint)) hasTouchId = true;
      if (biometrics && _biometrics.contains(BiometricType.face)) hasFaceId = true;
      if (biometrics && _biometrics.contains(BiometricType.iris)) hasFaceId = true;
      if (await Application.useVoiceAuth()) hasVoice = true;
      setState(() {});
    }
  }

  void _onBack() {
    AlertController.showNativeDialog(
      context: context,
      title: 'logout'.tr(),
      onYes: () async {
        await Application.setToken(null);
        AppRouter.toIntroPage(context);
      },
      onNo: () => Navigator.of(context).pop(),
    );
  }

  void _goToVoiceAuth() async {
    if (await Application.getWrongVoiceAttempts() > 3)
      return AlertController.showResultDialog(
        context: context,
        message: 'wrong_attempts_limited'.tr(),
        isSuccess: null,
      );
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => VoiceAuthenticationPage(mode: AuthMode.login, canEscape: true)));
  }

  void _setupControllers() {
    _contoller1 = AnimationController(vsync: this, duration: _duration);
    _contoller1.addListener(() => _controllerListener(_contoller1));
    _animation1 = Tween<Offset>(begin: Offset.zero, end: Offset(0, 0.3)).animate(_contoller1);

    _contoller2 = AnimationController(vsync: this, duration: _duration);
    _contoller2.addListener(() => _controllerListener(_contoller2));
    _animation2 = Tween<Offset>(begin: Offset.zero, end: Offset(0, 0.3)).animate(_contoller2);

    _contoller3 = AnimationController(vsync: this, duration: _duration);
    _contoller3.addListener(() => _controllerListener(_contoller3));
    _animation3 = Tween<Offset>(begin: Offset.zero, end: Offset(0, 0.3)).animate(_contoller3);

    _contoller4 = AnimationController(vsync: this, duration: _duration);
    _contoller4.addListener(() => _controllerListener(_contoller4));
    _animation4 = Tween<Offset>(begin: Offset.zero, end: Offset(0, 0.3)).animate(_contoller4);
  }

  void _init() async {
    if (widget.shouldSetupPin) return;

    _currentMessage = 'enter_pin_code'.tr();
    _pin = await Application.getPin() ?? '';
    setState(() {});
  }

  @override
  void initState() {
    _checkBiometrics();
    _init();
    _setupControllers();
    super.initState();
  }

  @override
  void dispose() {
    _contoller1.dispose();
    _contoller2.dispose();
    _contoller3.dispose();
    _contoller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: AppBackButton(onBack: _onBack)),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Application.isDarkMode(context) ? [AppColors.darkGrey, Colors.black45] : [AppColors.snow, AppColors.defaultGrey],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!widget.shouldSetupPin && (hasVoice || hasFaceId || hasTouchId)) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'use_biometrics'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (hasVoice)
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Icon(CupertinoIcons.mic_fill, size: 32),
                              onPressed: _goToVoiceAuth,
                            ),
                          if (hasFaceId)
                            CupertinoButton(
                              onPressed: _tryLoginWithBiometrics,
                              child: Image.asset(
                                AppIcons.faceId,
                                color: Application.isDarkMode(context) ? AppColors.lightAction : AppColors.darkAction,
                                width: 32,
                              ),
                            ),
                          if (hasTouchId)
                            CupertinoButton(
                              onPressed: _tryLoginWithBiometrics,
                              child: Image.asset(
                                AppIcons.touchId,
                                color: Application.isDarkMode(context) ? AppColors.lightAction : AppColors.darkAction,
                                width: 32,
                              ),
                            ),
                        ],
                      ),
                      const EmptyBox(height: 32),
                    ],
                    Text(_currentMessage, style: const TextStyle(fontSize: 20)),
                    const EmptyBox(height: 32),
                    ShakeWidget(
                      key: _shakeKey,
                      shakeCount: 3,
                      shakeOffset: 10,
                      shakeDuration: const Duration(milliseconds: 350),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AnimatedDot(animation: _animation1, isFilled: _tempPin.length > 0),
                            AnimatedDot(animation: _animation2, isFilled: _tempPin.length > 1),
                            AnimatedDot(animation: _animation3, isFilled: _tempPin.length > 2),
                            AnimatedDot(animation: _animation4, isFilled: _tempPin.length > 3),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
                      child: PinNumbers(onPressed: _numberPressed, onDelete: _onDelete),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _tryAnimatePinDots() {
    try {
      if (_tempPin.length == 1)
        _contoller1.forward();
      else if (_tempPin.length == 2)
        _contoller2.forward();
      else if (_tempPin.length == 3)
        _contoller3.forward();
      else if (_tempPin.length == 4) _contoller4.forward();
    } catch (e) {}
  }

  void _numberPressed(String value) async {
    if (_tempPin.length < 4) {
      _tempPin += value;
      setState(() {});
    }
    _tryAnimatePinDots();

    // Setting pin code
    if (widget.shouldSetupPin && _tempPin.length == 4 && _pin.isEmpty) {
      _pin = _tempPin;
      _tempPin = '';
      _currentMessage = 'repeat_pin_code'.tr();
      setState(() {});
      return;
    }

    // Login pin code
    if (!widget.shouldSetupPin && _tempPin.length == 4 && _tempPin == await Application.getPin()) {
      setState(() => isLoading = true);
      return _toMainPage();
    }

    // Repeating pin code
    if (_tempPin.length == 4 && _pin.length == 4) {
      if (_tempPin == _pin) {
        setState(() => isLoading = true);
        await Application.setPin(_pin);
        if (await Application.getWrongVoiceAttempts() > 3) Application.setWrongVoiceAttempts(0);
        await Future.delayed(const Duration(milliseconds: 200));
        if (widget.shouldSetupPin)
          return await AlertController.showNativeDialog(
            context: context,
            title: 'use_biometrics_for_login'.tr(),
            onYes: () async {
              await Application.setUseBiometrics(false);
              Navigator.of(context).pop();
              await _tryLoginWithBiometrics();
            },
            onNo: () async {
              await Application.setUseBiometrics(false);
              Navigator.of(context).pop();
              _toMainPage();
            },
          );
        _toMainPage();
      }
      _tempPin = '';
      if (widget.shouldSetupPin) {
        _incorrectAttempts += 1;
        if (_incorrectAttempts > 3) {
          _pin = '';
          _tempPin = '';
          _currentMessage = 'enter_pin_code'.tr();
        } else
          _currentMessage = 'incorrect_repeated_pin_code'.tr();
      } else {
        _incorrectAttempts += 1;
        if (_incorrectAttempts > 3) {
          return await Application.clearStorage(context: context);
        }
        _currentMessage = 'incorrect_pin_code'.tr();
      }
      _vibrate();
      setState(() {});
    }
  }

  void _onDelete() {
    if (_tempPin.isNotEmpty) {
      _tempPin = _tempPin.substring(0, _tempPin.length - 1);
      setState(() {});
    }
  }

  void _vibrate() {
    try {
      _shakeKey.currentState?.shake();
      HapticFeedback.mediumImpact();
    } catch (e) {}
  }
}

class AnimatedDot extends StatelessWidget {
  final Animation<Offset> animation;
  final bool isFilled;
  const AnimatedDot({Key? key, required this.animation, required this.isFilled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: Container(
        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
        decoration: BoxDecoration(
          color: isFilled ? (Application.isDarkMode(context) ? AppColors.metal : AppColors.grey) : AppColors.transparent,
          shape: BoxShape.circle,
          border: Border.all(width: 2.0, color: Application.isDarkMode(context) ? AppColors.metal : AppColors.grey),
        ),
      ),
    );
  }
}
