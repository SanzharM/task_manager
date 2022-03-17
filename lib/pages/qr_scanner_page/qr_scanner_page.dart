import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:easy_localization/easy_localization.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);
  @override
  QRScannerPageState createState() => QRScannerPageState();
}

class QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrController;

  bool isFlashOn = false;

  void _onQRViewCreated(QRViewController qrViewController) {
    _qrController = qrViewController;
    _qrController?.scannedDataStream.listen((event) {
      print(event.code);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
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
                onTap: () async => await openAppSettings(),
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
