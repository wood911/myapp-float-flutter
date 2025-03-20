import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../common/values/values.dart';
import '../sidebar/controller.dart';

class DrawingController extends GetxController {
  final GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();

  save() async {
    final image = await signaturePadKey.currentState!.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final OverlayController controller = Get.find<OverlayController>();
    if (byteData != null) {
      final data = byteData.buffer.asUint8List();
      controller.sendData({
        Values.cmdOverlayKey: Values.cmdSaveImage,
        'image': data,
      });
    }
  }
  clear() async {
    signaturePadKey.currentState?.clear();
  }
}
