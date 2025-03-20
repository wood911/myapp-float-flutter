import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interactive_slider/interactive_slider.dart';

import 'controller.dart';

class VolumeWidget extends GetView<VolumeController> {
  final double volume;
  const VolumeWidget(this.volume, {super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<VolumeController>(() => VolumeController());
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 190, 30, 0),
      child: InteractiveSlider(
        initialProgress: volume,
        iconPosition: IconPosition.inside,
        startIcon: Icon(CupertinoIcons.volume_down, color: Colors.white),
        endIcon: Icon(CupertinoIcons.volume_up, color: Colors.white),
        // centerIcon: Obx(() => Text('${controller.volume.value}')),
        backgroundColor: Colors.black54,
        foregroundColor: Colors.blueAccent,
        unfocusedHeight: 40,
        focusedHeight: 50,
        iconGap: 16,
        onChanged: controller.onChanged,
        onProgressUpdated: controller.onComplete,
      ),
    );
  }

}

