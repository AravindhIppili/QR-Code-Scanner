import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Animate extends GetxController with SingleGetTickerProviderMixin{
  late Rx<AnimationController> animationController;
  

  @override
  void onInit() {
    super.onInit();
    animationController =
            AnimationController(duration: const Duration(seconds: 1), vsync: this).obs;
    animationController.value.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.value.dispose();
  }
}
