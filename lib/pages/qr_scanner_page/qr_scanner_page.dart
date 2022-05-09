import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:easy_localization/easy_localization.dart';

import 'bloc/qr_bloc.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);
  @override
  QRScannerPageState createState() => QRScannerPageState();
}

class QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrController;

  final _bloc = QrBloc();

  final _geocoding = geocoding.GeocodingPlatform.instance;
  Location _location = Location();

  bool isFlashOn = false;

  void _onQRViewCreated(QRViewController qrViewController) {
    _qrController = qrViewController;
    _qrController?.scannedDataStream.listen((event) {
      print(event.code);
      setState(() {});
    });
  }

  void _requestPermissions() async {
    final status = await _location.requestPermission();
    if (status == PermissionStatus.granted || status == PermissionStatus.grantedLimited) return;

    WidgetsBinding.instance?.addPostFrameCallback(
      (timeStamp) => AlertController.showSimpleDialog(
        context: context,
        message: '',
      ),
    );
  }

  void func() async {
    // await ApiClient.setSession();
    // await ApiClient.getSessions();
  }

  Future<geocoding.Placemark?> getCurrentLocation() async {
    final data = await _location.getLocation();
    if (data.latitude == null || data.longitude == null) return null;
    return (await _geocoding.placemarkFromCoordinates(data.latitude!, data.longitude!)).first;
  }

  @override
  void initState() {
    super.initState();
    // _bloc.getSessions();
    _requestPermissions();
  }

  @override
  void dispose() {
    _qrController?.dispose();
    super.dispose();
  }

  void stopCamera() async => await _qrController?.stopCamera();
  void resumeCamera() async {
    await _qrController?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _qrController?.hasPermissions ?? true
          ? SafeArea(
              child: Stack(
                children: [
                  QRView(
                    key: _qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Application.isDarkMode(context) ? AppColors.defaultGrey : AppColors.grey,
                      borderRadius: 2,
                      overlayColor: const Color.fromRGBO(0, 0, 0, 60),
                      borderLength: 60,
                      borderWidth: 10,
                      cutOutWidth: MediaQuery.of(context).size.width - 90,
                      cutOutHeight: MediaQuery.of(context).size.width - 90,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        color: AppColors.defaultGrey.withOpacity(0.5),
                        padding: EdgeInsets.zero,
                        icon: isFlashOn ? const Icon(Icons.flashlight_on, size: 32) : const Icon(Icons.flashlight_off, size: 32),
                        onPressed: () async {
                          isFlashOn = await _qrController?.getFlashStatus() ?? false;
                          await _qrController?.toggleFlash();
                          setState(() {});
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: GestureDetector(
                onTap: () async => await permission.openAppSettings(),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'allow_access_to_camera_error_msg'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
    );
  }
}
