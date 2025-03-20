import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'controller.dart';

class DrawingPage extends GetView<DrawingController> {

  const DrawingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<DrawingController>(() => DrawingController());
    return Stack(
      children: [
        Column(children: [
          Expanded(
            child: SfSignaturePad(
              key: controller.signaturePadKey,
              minimumStrokeWidth: 5,
              maximumStrokeWidth: 8,
              strokeColor: Colors.red,
              backgroundColor: Colors.transparent,
            ),
          )
        ]),
        Align(
          alignment: Alignment(0, 0.9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () => controller.clear(), child: Text("清除")),
              ElevatedButton(onPressed: () => controller.save(), child: Text("保存")),
            ],
          ),
        ),
      ],
    );
  }
}
