import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_extend/share_extend.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/widgets/app_cells.dart';

class GenerateQrPage extends StatefulWidget {
  const GenerateQrPage({Key? key}) : super(key: key);

  @override
  State<GenerateQrPage> createState() => _GenerateQrPageState();
}

class _GenerateQrPageState extends State<GenerateQrPage> {
  final GlobalKey _qrKey = GlobalKey();
  String? companyCode;
  bool isLoading = true;

  void _showError(String message, {bool? isSuccess}) =>
      AlertController.showResultDialog(context: context, message: message, isSuccess: isSuccess);

  Future<void> _init() async {
    companyCode = await Application.getCompanyCode();
    isLoading = false;
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _shareQr() async {
    Navigator.of(context).pop();
    if (companyCode == null) return _showError('cannot_get_qr'.tr());
    final filePath = await getQrImage();
    if (filePath == null) return _showError('cannot_share_qr'.tr());
    await ShareExtend.share(filePath, 'image');
  }

  Future<void> _saveToGallery() async {
    Navigator.of(context).pop();
    final status = await Permission.photos.request();
    if (!status.isGranted) return _showError('allow_photos_permissions'.tr());
    if (companyCode == null) return _showError('cannot_get_qr'.tr());

    final filePath = await getQrImage();
    if (filePath == null) {
      return _showError('cannot_save_qr'.tr());
    }

    final res = await GallerySaver.saveImage(filePath);
    if (res == true) {
      return _showError('qr_saved'.tr(), isSuccess: true);
    }
    return _showError('cannot_save_qr'.tr());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: AppCloseButton(),
        actions: [
          CupertinoButton(child: const Icon(Icons.more_vert_rounded), onPressed: _showActions),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, animation) => SizeTransition(sizeFactor: animation, child: child),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: RepaintBoundary(
                    key: _qrKey,
                    child: QrImage(
                      data: Application.getBaseUrl() + '/session/?company_code=' + (companyCode ?? ''),
                      size: MediaQuery.of(context).size.width * 0.66,
                      foregroundColor: Application.isDarkMode(context) ? AppColors.metal : AppColors.darkGrey,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void _showActions() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: AppConstraints.borderRadius),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (context) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              OneLineCell(
                title: 'share'.tr(),
                onTap: _shareQr,
                leading: const Icon(CupertinoIcons.share),
                icon: const Icon(CupertinoIcons.forward),
              ),
              const SizedBox(height: 16.0),
              OneLineCell(
                title: 'save_to_gallery'.tr(),
                onTap: _saveToGallery,
                leading: const Icon(CupertinoIcons.photo_fill),
                icon: const Icon(CupertinoIcons.forward),
              ),
              const SizedBox(height: 20.0),
              OneLineCell(
                title: 'done'.tr(),
                onTap: () => Navigator.of(context).pop(),
                centerTitle: true,
                needIcon: false,
              ),
            ],
          ),
        ),
      );

  Future<String?> getQrImage() async {
    final boundary = _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 5.0);
    final byteData = await (image.toByteData(format: ImageByteFormat.png));
    if (byteData != null) {
      final pngBytes = byteData.buffer.asUint8List();
      final directory = (await getApplicationDocumentsDirectory()).path;
      final imgFile = File('$directory/$companyCode-QR.png');
      imgFile.writeAsBytes(pngBytes);
      return imgFile.path;
    }
    return null;
  }
}
