import 'package:flutter/cupertino.dart';

class Values {
  static const String kPortNameOverlay = 'OVERLAY';
  static const String kPortNameHome = 'UI';

  static const String cmdOverlayKey = 'cmd';
  static const String cmdCloseOverlay = 'close';
  static const String cmdResizeOverlay = 'resize';
  static const String cmdSetOverlayFlag = 'flag';
  static const String cmdRecordStatus = 'record_status';
  static const String cmdScreenShare = 'screen_share';
  static const String cmdSaveImage = 'save_image';
  static const String cmdScreenshot = 'screenshot';
  static const String cmdGoBack = 'go_back';
  static const String cmdSwitchTask = 'switch_task';

  static const int menuCount = 8;

}

class App {
  static double width = 393;
  static double height = 852;
  static double pixelRatio = 3;
  static init(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    pixelRatio = MediaQuery.of(context).devicePixelRatio;
  }
}