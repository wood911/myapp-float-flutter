import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';

import '../../common/utils/logger.dart';
import '../../common/values/values.dart';
import '../sidebar/controller.dart';

class DrawPainter extends StatefulWidget {
  const DrawPainter({super.key});

  @override
  State<DrawPainter> createState() => _DrawPainterState();
}

class _DrawPainterState extends State<DrawPainter> {
  final ImagePainterController _controller = ImagePainterController(
    color: Colors.red,
    strokeWidth: 5,
  );
  String? _imgPath;

  @override
  void initState() {
    super.initState();
    _initImage();
  }

  _initImage() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    final filePath = '$directory/transparent.png';
    if (!File(filePath).existsSync()) {
      final width = (App.width * App.pixelRatio).toInt();
      final height = (App.height * App.pixelRatio).toInt();
      Log.d('width: $width, height: $height');
      // 全部填充 0，RGBA 全透明
      final image = img.Image(width: width, height: height, numChannels: 4);
      image.backgroundColor = img.ColorInt8.rgba(0, 0, 0, 0);
      // 转换为 PNG 格式
      await img.writeFile(filePath, img.encodePng(image));
    }
    Log.d(filePath);
    setState(() {
      _imgPath = filePath;
    });
 }

 onClose() {
   OverlayController controller = Get.find();
   controller.showDrawingPad();
 }

  @override
  Widget build(BuildContext context) {
    if (_imgPath == null) {
      return SizedBox.shrink();
    }
    return Column(
      children: [
        Expanded(
          child: ImagePainter.file(
            File(_imgPath!),
            controller: _controller,
            controlsBackgroundColor: Colors.black54,
            optionColor: Colors.white,
            controlsAtTop: false,
            onClose: onClose,
          )
        ),
      ]
    );
  }

}