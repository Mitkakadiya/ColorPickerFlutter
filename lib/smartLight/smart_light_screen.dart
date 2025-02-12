import 'dart:math';
import 'package:color_picker_flutter/smartLight/smart_light_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmartLightScreen extends StatelessWidget {
  SmartLightScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SmartLightController>(
        init: SmartLightController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF1C1C1E),
              title: Text("Color Picker",style: TextStyle(
                color: Color(0xFFFFFFFF)
              ),),
              actions: [
                GestureDetector(
                    onTap: () {
                      controller.isFavourite.value =
                          !controller.isFavourite.value;

                      print(controller.isFavourite.value);
                    },
                    child: Obx(
                      () => Image.asset(
                        controller.isFavourite.value == true
                            ? "assets/icon/filled_heart.png"
                            : "assets/icon/heart.png",
                        height: 30,
                        width: 30,
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                Image.asset(
                  "assets/icon/setting.png",
                  height: 30,
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
              ],
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Color(0xFFFFFFFF),
                  )),
            ),
            backgroundColor: Color(0xFF1C1C1E),
            body: myBody(controller: controller, context: context),
          );
        },
    );
  }

  myBody(
      {required BuildContext context,
      required SmartLightController controller}) {
    return colorBar(context, controller);
  }

  Widget colorBar(BuildContext context, SmartLightController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Obx(() => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.minHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "Office Lifx",
                                style: TextStyle(color: Color(0xFFFFFFFF)),
                              ),
                              Text(
                                controller.colorToHex(),
                                style: TextStyle(color: Color(0xFFFFFFFF)),
                              ),
                            ],
                          ),
                          SizedBox(width: 20,),
                          Container(
                            decoration: BoxDecoration(
                              color: controller.selectedColor.value,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            height: 40,
                            width: 100,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(children: [
                              Center(
                                child: IgnorePointer(
                                  ignoring: !controller.isLampOn.value,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onPanStart: (details) {
                                      controller.startAngle.value =
                                          controller.calculateAngle(
                                        details.localPosition.dx,
                                        details.localPosition.dy,
                                      );
                                      controller.previousAngle.value =
                                          controller.rotationAngle.value;
                                    },
                                    onPanUpdate: (details) {
                                      double touchX = details.localPosition.dx;
                                      double touchY = details.localPosition.dy;
                                      double currentAngle = controller
                                          .calculateAngle(touchX, touchY);
                                      double angleDifference = currentAngle -
                                          controller.startAngle.value;
                                      controller.rotationAngle.value =
                                          ((controller.previousAngle.value +
                                              angleDifference));
                                      controller.selectedColor.value =
                                          controller.colorFromAngle();
                                    },
                                    child: Transform.rotate(
                                      angle: controller.rotationAngle.value *
                                          pi /
                                          180,
                                      child: Opacity(
                                        opacity:
                                            controller.isLampOn.value ? 1 : 0.5,
                                        child: Image.asset(
                                          "assets/icon/icon_color_picker.png",
                                          height: 313,
                                          width: 313,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.isLampOn.value =
                                          !controller.isLampOn.value;
                                    },
                                    child: Image.asset(
                                      controller.isLampOn.value
                                          ? "assets/icon/button_off.png"
                                          : "assets/icon/button_on.png",
                                      height: 101,
                                      width: 101,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          width: 2, color: Color(0xFF3E92CC))),
                                  height: 70.5,
                                  width: 13,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 70.5),
                                child: Center(
                                  child: Image.asset(
                                    "assets/icon/polygon.png",
                                    height: 17,
                                    width: 17,
                                  ).paddingOnly(right: 3),
                                ),
                              ),
                              Positioned(
                                left:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                top: controller.thumbYPosition.value,
                                child: IgnorePointer(
                                  ignoring: !controller.isLampOn.value,
                                  child: GestureDetector(
                                    onPanUpdate: (details) {
                                      double newY =
                                          controller.thumbYPosition.value +
                                              details.delta.dy;
                                      double clampedY = newY.clamp(
                                          controller.minY, controller.maxY);
                                      controller.thumbYPosition.value =
                                          clampedY;
                                      controller.selectedColor.value =
                                          controller.colorFromAngle();
                                    },
                                    child: Obx(
                                      () => Container(
                                        width: 21,
                                        height: 21,
                                        decoration: BoxDecoration(
                                            color:
                                                controller.selectedColor.value,
                                            border: Border.all(
                                                width: 2,
                                                color: Color(0xFF3E92CC)),
                                            borderRadius:
                                                BorderRadius.circular(21)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            SizedBox(
                              height: 40,
                            ),
                            IgnorePointer(
                                ignoring: !controller.isLampOn.value,
                                child: customProgressBar(
                                    context: context, controller: controller)),
                            SizedBox(
                              height: 25,
                            ),
                            Center(
                                child: Obx(
                              () => Text(
                                "Brightness ${controller.isLampOn.value ? (controller.progress.value * 100).toInt() : 0}%",
                                style: TextStyle(color: Color(0xFFE9EBED)),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 20),
                ),
              ),
            ));
      },
    );
  }

  Widget customProgressBar({
    required BuildContext context,
    required SmartLightController controller,
  }) {
    return Stack(
      children: [
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) {
              final double width = MediaQuery.of(context).size.width - 40;
              controller.progress.value = controller.isLampOn.value
                  ? (details.localPosition.dx / width).clamp(0.0, 1.0)
                  : 0;
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFF303133),
                  borderRadius: BorderRadius.circular(15)),
              height: 72,
              width: double.maxFinite,
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                  child: Container(
                    width: controller.isLampOn.value
                        ? MediaQuery.of(context).size.width *
                            controller.progress.value
                        : 0,
                    decoration: BoxDecoration(
                      color: Color(0xFFAA6FC6),
                      borderRadius: BorderRadius.circular(0),
                      border: Border(
                        right: BorderSide(
                            color: Color(0xFFFFFFFF),
                            width: 10), // Right-side border
                      ),
                    ),
                  ),
                ),
              ]),
            )),
      ],
    );
  }
}
