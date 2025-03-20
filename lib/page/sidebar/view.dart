import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/drawing/view.dart';
import 'package:myapp/page/volume/view.dart';

import 'controller.dart';

class SidebarOverlay extends GetView<OverlayController> {
  const SidebarOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<OverlayController>(() => OverlayController());
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        _buildExtra(context),
        _buildMenu(context),
      ],
    );
  }

  _buildExtra(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Obx(() {
        if (controller.showVolume.value) {
          return VolumeWidget(controller.volume);
        } if (controller.showDrawing.value) {
          return DrawingPage();
        }
        return SizedBox.shrink();
      }),
    );
  }

  _buildMenu(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        color: Colors.black54,
        width: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.home, color: Colors.white), onPressed: controller.backHome),
            IconButton(icon: Icon(Icons.arrow_back, color: Colors.white), onPressed: controller.goBack),
            IconButton(icon: Icon(Icons.menu, color: Colors.white), onPressed: controller.appSwitch),
            IconButton(icon: Icon(Icons.brush, color: Colors.white), onPressed: () => controller.showDrawingPad(context)),
            IconButton(icon: Icon(Icons.volume_up, color: Colors.white), onPressed: () => controller.showVolumeSlider(context)),
            IconButton(icon: Icon(Icons.photo, color: Colors.white), onPressed: controller.captureScreen),
            IconButton(icon: Obx(() => controller.isRecording.value
                ? Icon(Icons.fiber_manual_record, color: Colors.red)
                : Icon(Icons.videocam, color: Colors.white)),
                onPressed: controller.startScreenRecording),
            IconButton(icon: Icon(Icons.close, color: Colors.white), onPressed: controller.closeOverlay),
          ],
        ),
      ),
    );
  }
}
