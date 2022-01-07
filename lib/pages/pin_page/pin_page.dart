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

  // ignore: unused_element
  void _vibrate() {
    try {
      HapticFeedback.lightImpact();
    } catch (e) {}
  }

  void _numberPressed(String value) {
    if (_pin.length < 4) {
      _pin += value;
      setState(() {});
    }
    if (_pin.length == 4) {
      // validate pins
      print('$_tempPin == $_pin');
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      _pin = _pin.substring(0, _pin.length - 1);
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
        final route = CupertinoPageRoute(builder: (context) => NavigationBar());
        Navigator.of(context).pushReplacement(route);
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
        child: Column(
          children: [
            EmptyBox(height: 24),
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
                : EmptyBox(),
            EmptyBox(height: 48),
            PinDots(length: 4, pin: _pin),
            EmptyBox(height: 48),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PinNumbers(onPressed: _numberPressed, onDelete: _onDelete),
            ),
          ],
        ),
      ),
    );
  }
}
