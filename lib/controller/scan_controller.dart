import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode_scanner/data/scan_data.dart';

class ScanController extends GetxController {
  var controller;
  var barcodeResult;
  var flashIcon = Icons.flash_off.obs;

  Rx<int> barcodefound = 0.obs;

  var camPermission = true.obs;

  void updateContoller(QRViewController cont) {
    controller = cont.obs;
    controller.value.scannedDataStream.listen((scanData) {
      if (scannedData.indexWhere((element) => element.text == scanData.code) ==
              -1 ||
          scannedData.length == 0) {
        scannedData.add(ScannedData(
            text: scanData.code,
            time: DateTime.now().toString().split(" ")[1].substring(0, 8)));
      }
      barcodeResult = scanData;
      barcodefound(barcodefound.value+1);
    });
  }
  
  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}
