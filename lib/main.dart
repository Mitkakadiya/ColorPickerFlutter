import 'package:color_picker_flutter/smartLight/smart_light_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: "YourFont", // Optional: Add your app's font
    ),
    home: SmartLightScreen(),
  ));
}

