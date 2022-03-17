import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:task_manager/core/app_icons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/pin_page/pin_widgets.dart';
import 'package:task_manager/pages/navigation_bar.dart';

class PinPage extends StatefulWidget {
  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final _localAuth = LocalAuthentication();
  String _tempPin = '';
  String _pin = '';

  bool hasTouchId = false;
  bool hasFaceId = false;

  String _currentMessage = 'Установите пин-код';
  int _retryCounter = 0;

  void _vibrate() {
    try {
      HapticFeedback.lightImpact();
    } catch (e) {}
  }

  void _toMainPage() {
    final route = CupertinoPageRoute(builder: (context) => NavigationBar());
    Navigator.of(context).pushReplacement(route);
  }

  void _numberPressed(String value) {
    if (_tempPin.length < 4) {
      _tempPin += value;
      setState(() {});
    }
    if (_tempPin.length == 4 && _pin.isEmpty) {
      _pin = _tempPin;
      _tempPin = '';
      _currentMessage = 'Повторите пин-код';
      setState(() {});
      return;
    }
    if (_tempPin.length == 4 && _pin.length == 4) {
      if (_tempPin == _pin) {
        _toMainPage();
        return;
      } else if (_retryCounter < 3) {
        _tempPin = '';
        _currentMessage = 'Повторный пин-код неверный';
        _retryCounter++;
        setState(() {});
      } else {
        _currentMessage = 'Установите пин-код';
        _tempPin = '';
        _pin = '';
        _retryCounter = 0;
        setState(() {});
      }
      _vibrate();
    }
  }

  void _onDelete() {
    if (_tempPin.isNotEmpty) {
      _tempPin = _tempPin.substring(0, _tempPin.length - 1);
      setState(() {});
    }
  }

  void _tryLoginWithBiometrics() async {
    try {
      bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Авторизуйтесь, чтобы пользоваться приложением',
      );
      if (didAuthenticate) {
        // Send login request
        _toMainPage();
      }
    } catch (e) {
      print('Unable to local auth. Error: $e');
    }
  }

  void _checkBiometrics() async {
    if (await _localAuth.isDeviceSupported()) {
      final _biometrics = await _localAuth.getAvailableBiometrics();
      if (_biometrics.contains(BiometricType.fingerprint)) hasTouchId = true;
      if (_biometrics.contains(BiometricType.face)) hasFaceId = true;
      if (_biometrics.contains(BiometricType.iris)) hasFaceId = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    _checkBiometrics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmptyBox(height: 12),
            Text(_currentMessage, style: const TextStyle(fontSize: 20)),
            const EmptyBox(height: 24),
            hasFaceId || hasTouchId
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (hasFaceId)
                          IconButton(
                            icon: Image.asset(AppIcons.faceId, width: 48),
                            onPressed: () => _tryLoginWithBiometrics(),
                          ),
                        if (hasTouchId)
                          IconButton(
                            icon: Image.asset(AppIcons.touchId, width: 48),
                            onPressed: () => _tryLoginWithBiometrics(),
                          ),
                      ],
                    ),
                  )
                : const EmptyBox(),
            const EmptyBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: PinDots(length: 4, pin: _tempPin),
            ),
            const EmptyBox(height: 56),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: PinNumbers(onPressed: _numberPressed, onDelete: _onDelete),
            ),
          ],
        ),
      ),
    );
  }
}
