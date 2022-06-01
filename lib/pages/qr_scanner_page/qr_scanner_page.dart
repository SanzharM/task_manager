import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/supporting/app_router.dart';

import 'bloc/qr_bloc.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key, required this.changeTab, this.onSessionCreated}) : super(key: key);

  final void Function()? onSessionCreated;
  final void Function(int index) changeTab;

  @override
  QRScannerPageState createState() => QRScannerPageState();
}

class QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrController;

  final _bloc = QrBloc();

  Location _location = Location();

  bool isFlashOn = false;
  bool isLoading = false;

  void _onQRViewCreated(QRViewController qrViewController) {
    _qrController = qrViewController;
    _qrController?.scannedDataStream.listen((event) async {
      if (!isLoading && (event.code?.contains(Application.getBaseUrl()) ?? false)) {
        isLoading = true;
        _bloc.createSession(await _location.getLocation());
        setState(() {});
      }
    });
  }

  void _requestPermissions() async {
    final cameraPermissions = await permission.Permission.camera.request();
    if (cameraPermissions == permission.PermissionStatus.granted || cameraPermissions == permission.PermissionStatus.limited) return;
    setState(() {});

    final status = await _location.requestPermission();
    if (status == PermissionStatus.granted || status == PermissionStatus.grantedLimited) return;

    WidgetsBinding.instance?.addPostFrameCallback(
      (timeStamp) => AlertController.showSimpleDialog(
        context: context,
        message: 'allow_location_permissions'.tr(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
          ? BlocListener(
              bloc: _bloc,
              listener: (context, state) async {
                print('state is $state');
                isLoading = state is QrLoading;

                if (state is ErrorState) {
                  await AlertController.showResultDialog(context: context, message: state.error, isSuccess: null);
                }

                if (state is QrSessionCreated) {
                  widget.changeTab(2);
                  if (widget.onSessionCreated != null)
                    widget.onSessionCreated!();
                  else
                    AppRouter.toSessionsPage(context: context);
                }

                setState(() {});
              },
              child: SafeArea(
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
                    ),
                    if (isLoading)
                      Container(
                        height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top,
                        width: double.maxFinite,
                        color: Application.isDarkMode(context) ? AppColors.metal.withOpacity(0.33) : AppColors.darkGrey.withOpacity(0.33),
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 48, maxHeight: 48),
                          child: CircularProgressIndicator(color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                      ),
                  ],
                ),
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
