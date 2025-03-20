import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:volume_control/volume_control.dart';

import '../../common/utils/logger.dart';
import '../../common/values/values.dart';

class OverlayController extends GetxController {
  var showVolume = false.obs;
  var showDrawing = false.obs;
  var isRecording = false.obs;
  double volume = 0.0;

  final _receivePort = ReceivePort();
  SendPort? homePort;

  @override
  void onInit() {
    super.onInit();
    _initPort();
  }

  _initPort() {
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      Values.kPortNameOverlay,
    );
    _receivePort.listen((message) {
      Log.d("message from host: $message");
      final cmd = message[Values.cmdOverlayKey] ?? '';
      if (cmd == Values.cmdRecordStatus) {
        isRecording.value = message['status'] as bool;
      }
    });
  }

  sendData(Object data) {
    homePort ??= IsolateNameServer.lookupPortByName(
      Values.kPortNameHome,
    );
    homePort?.send(data);
  }

  backHome() {
    MoveToBackground.goHome();
  }
  appSwitch() {
    MoveToBackground.appSwitch();
  }
  goBack() {
    SystemNavigator.pop();
    MoveToBackground.moveTaskToBack();
  }
  showDrawingPad(BuildContext context) {
    if (showDrawing.value) {
      FlutterOverlayWindow.resizeOverlay(50, 50 * 8, false);
    } else {
      FlutterOverlayWindow.resizeOverlay(WindowSize.fullCover, WindowSize.matchParent, false);
    }
    showVolume.value = false;
    showDrawing.value = !showDrawing.value;
  }
  showVolumeSlider(BuildContext context) async {
    if (showVolume.value) {
      FlutterOverlayWindow.resizeOverlay(50, 50 * 8, false);
    } else {
      FlutterOverlayWindow.resizeOverlay(WindowSize.fullCover, 50 * 8, false);
    }
    volume = await VolumeControl.volume;
    Log.d('system volume:$volume');
    showDrawing.value = false;
    showVolume.value = !showVolume.value;
  }
  startScreenRecording() async {
    showVolume.value = false;
    showDrawing.value = false;
    sendData({Values.cmdOverlayKey: Values.cmdScreenShare});
  }
  captureScreen() async {
    sendData({Values.cmdOverlayKey: Values.cmdScreenshot});
  }
  closeOverlay() {
    FlutterOverlayWindow.closeOverlay();
  }

  Future<bool> startForegroundService() async {
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "myapp录制屏幕",
      notificationText: "Background notification for keeping the app running in the background",
      notificationImportance: AndroidNotificationImportance.normal,
      notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    await FlutterBackground.initialize(androidConfig: androidConfig);
    return FlutterBackground.enableBackgroundExecution();
  }
}
