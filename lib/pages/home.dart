import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode_scanner/controller/scan_controller.dart';
import 'package:qrcode_scanner/pages/scan_animation.dart';
import 'package:qrcode_scanner/pages/view_scans.dart';

class HomePage extends StatelessWidget {
  final GlobalKey qrScanner = GlobalKey(debugLabel: 'QRCode');

  final stateContoller = Get.put(ScanController());

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
                stateContoller.camPermission(false);
              } else {
                stateContoller.camPermission(true);
              }
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
              stateContoller.camPermission.value
                  ? ""
                  : "Give Camera Permission!",
              style: TextStyle(fontSize: 25, color: Colors.red),
            )),
          ),
          ScanAnimation(),
          buildScannedOutput(),
          buildFlashButton(),
          Positioned(
            bottom: 30,
            child: Container(
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => ViewScans());
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

  Widget buildFlashButton() {
    return Obx(
      () => Positioned(
        top: 20,
        child: Container(
          child: IconButton(
            icon: Icon(
              stateContoller.flashIcon.value,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () async {
              stateContoller.controller.value?.toggleFlash();
              if (stateContoller.flashIcon.value == Icons.flash_on) {
                stateContoller.flashIcon(Icons.flash_off);
              } else {
                stateContoller.flashIcon(Icons.flash_on);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildScannedOutput() {
    return Obx(
      () => Positioned(
        bottom: 100,
        left: 0,
        right: 0,
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              stateContoller.barcodefound.value > 0
                  ? stateContoller.barcodeResult.code
                  : "Scan Something",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    stateContoller.updateContoller(controller);
  }
}
