import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmartLightController extends GetxController {
  RxDouble rotationAngle = (0.0).obs;
  RxDouble previousAngle = (0.0).obs;
  RxDouble startAngle = (0.0).obs;
   var thumbYPosition = 0.0.obs; // Initial Y position
  final double minY = 0;  // Top limit
  final double maxY = 49.5;   // Bottom limit
  var selectedColor = Rx<Color>(Colors.red); //
  RxDouble progress = 0.0.obs;
  RxBool isFavourite = RxBool(false);
  RxBool isLampOn = RxBool(false);

  double calculateAngle(double touchX, double touchY) {
    double deltaX = touchX - (313/2);
    double deltaY = touchY - (313/2);
    return atan2(deltaY, deltaX) * (180 / pi); // Convert radians to degrees
  }

  double normalizeValue(double value, double min, double max) {
    return (value - min) / (max - min);
  }

  Color colorFromAngle() {
    HSVColor hsvColor = HSVColor.fromAHSV(1.0,(360-angleToHue(rotationAngle.value)),(1-normalizeValue(thumbYPosition.value, 0, 49.5)), 1.0);
    return hsvColor.toColor();
  }

  String colorToHex() {
    return "#${selectedColor.value.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";
  }

  double angleToHue(double angle) {
    double hue = angle % 360;
    if (hue < 0) {
      hue += 360;
    }
    return hue;
  }

}
