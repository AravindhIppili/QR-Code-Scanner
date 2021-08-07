import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrcode_scanner/controller/animate.dart';

class ScanAnimation extends StatelessWidget {
  final Tween<Offset> _tween = Tween(begin: Offset(0, -7), end: Offset(0, 7));
  final animateController = Get.put(Animate());
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Obx(() => SlideTransition(
            position: _tween.animate(CurvedAnimation(
                parent: animateController.animationController.value, curve: Curves.easeInOut)),
            child: Container(
              width: 240,
              child: Divider(
                thickness: 2,
                color: Colors.red,
              ),
            ),
          ),
        ));
  }
}
