import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:task_manager/core/app_colors.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
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

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrController?.pauseCamera();
    } else if (Platform.isIOS) {
      _qrController?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _qrController?.hasPermissions ?? true
          ? SafeArea(
              child: Stack(
                children: [
                  QRView(key: _qrKey, onQRViewCreated: _onQRViewCreated),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                        border: Border.all(width: 2.0, color: AppColors.yellow),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        color: AppColors.defaultGrey.withOpacity(0.5),
                        padding: EdgeInsets.zero,
                        icon: isFlashOn
                            ? const Icon(Icons.flashlight_on, size: 32)
                            : const Icon(Icons.flashlight_off, size: 32),
                        onPressed: () async {
                          isFlashOn =
                              await _qrController?.getFlashStatus() ?? false;
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
                // onTap: () async => await openAppSettings(),
                child: const Text(
                  'Предоставьте доступ к камере, чтобы сканировать QR-коды',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ),
    );
  }
}
