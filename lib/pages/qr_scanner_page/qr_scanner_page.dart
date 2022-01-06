import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Icon(CupertinoIcons.qrcode, size: 60),
      ),
    );
  }
}
