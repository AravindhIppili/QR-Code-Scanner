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

class _HomePageState extends State<HomePage> {
  Barcode? barcodeResult;
  final GlobalKey qrScanner = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  IconData flashIcon = Icons.flash_off;

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
            overlay: QrScannerOverlayShape(
                cutOutSize: MediaQuery.of(context).size.width * 0.7,
                borderWidth: 10.0,
                borderRadius: 10,
                borderLength: 30,
                cutOutBottomOffset: 1),
          ),
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
                  child: Text("View Scans")),
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
      child: Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            barcodeResult != null ? barcodeResult!.code : "Scan Something",
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scannedData.any((element) => element.text != scanData.code) ||
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
    super.dispose();
  }
}
