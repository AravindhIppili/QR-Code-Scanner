import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode_scanner/data/scan_data.dart';
import 'package:qrcode_scanner/pages/view_scans.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Barcode? barcodeResult;
  final GlobalKey qrScanner = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  IconData flashIcon = Icons.flash_off;
  late AnimationController _animationController;
  Tween<Offset> _tween = Tween(begin: Offset(0, -7), end: Offset(0, 7));
  bool camPermission = true;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animationController.repeat(reverse: true);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: qrScanner,
            onQRViewCreated: _onQRViewCreated,
            onPermissionSet: (controller, isSet) {
              if (isSet == false) {
                camPermission = false;
              } else {
                camPermission = true;
              }
              setState(() {});
            },
            overlay: QrScannerOverlayShape(
                cutOutSize: MediaQuery.of(context).size.width * 0.7,
                borderWidth: 10.0,
                borderRadius: 10,
                borderLength: 30,
                cutOutBottomOffset: 1),
          ),
          Positioned(
            top: 100,
            child: Container(
                child: Text(
              camPermission ? "" : "Give Camera Permission!",
              style: TextStyle(fontSize: 25, color: Colors.red),
            )),
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: SlideTransition(
                position: _tween.animate(CurvedAnimation(
                    parent: _animationController, curve: Curves.easeInOut)),
                child: Container(
                  width: 240,
                  child: Divider(
                    thickness: 2,
                    color: Colors.red,
                  ),
                ),
              )),
          buildScannedOutput(),
          buildFlashButton(),
          Positioned(
            bottom: 30,
            child: Container(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ViewScans()));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.qr_code,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Text("View Scans"),
                    ],
                  )),
            ),
          ),
        ],
      ),
    ));
  }

  Positioned buildFlashButton() {
    return Positioned(
      top: 20,
      child: Container(
        child: IconButton(
          icon: Icon(
            flashIcon,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () async {
            setState(() {
              controller?.toggleFlash();
              if (flashIcon == Icons.flash_on) {
                flashIcon = Icons.flash_off;
              } else {
                flashIcon = Icons.flash_on;
              }
            });
          },
        ),
      ),
    );
  }

  Positioned buildScannedOutput() {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Container(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              barcodeResult != null ? barcodeResult!.code : "Scan Something",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scannedData.indexWhere((element) => element.text == scanData.code) ==
              -1 ||
          scannedData.length == 0) {
        scannedData.add(ScannedData(
            text: scanData.code,
            time: DateTime.now().toString().split(" ")[1].substring(0, 8)));
      }
      setState(() {
        barcodeResult = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
