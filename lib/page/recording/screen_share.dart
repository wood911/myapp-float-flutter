import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:get/get.dart' hide navigator;
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../common/utils/logger.dart';

class ScreenShareController extends GetxController {
  static String tag = 'get_display_media_sample';
  MediaStream? localStream;
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  var inCalling = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    initRenderers();
  }
  Future<void> initRenderers() async {
    Log.d('initRenderers');
    await localRenderer.initialize();
  }
  @override
  void onClose() {
    if (inCalling.value) {
      _stop();
    }
    localRenderer.dispose();
    super.onClose();
  }

  Future<void> requestBackgroundPermission([bool isRetry = false]) async {
    // Required for android screenshare.
    try {
      var hasPermissions = await FlutterBackground.hasPermissions;
      if (!isRetry) {
        const androidConfig = FlutterBackgroundAndroidConfig(
          notificationTitle: '屏幕共享',
          notificationText: 'myapp需要共享您的屏幕',
          notificationImportance: AndroidNotificationImportance.normal,
          notificationIcon: AndroidResource(
              name: 'ic_launcher', defType: 'mipmap'),
        );
        hasPermissions = await FlutterBackground.initialize(
            androidConfig: androidConfig);
      }
      if (hasPermissions &&
          !FlutterBackground.isBackgroundExecutionEnabled) {
        await FlutterBackground.enableBackgroundExecution();
      }
    } catch (e) {
      if (!isRetry) {
        return await Future<void>.delayed(const Duration(seconds: 1),
                () => requestBackgroundPermission(true));
      }
      Log.d('could not publish video: $e');
    }
  }

  Future<bool> startScreenShare() async {
    Log.d('startScreenShare');
    final isGranted = await Helper.requestCapturePermission();
    if (!isGranted) {
      Log.d('请运行屏幕共享权限');
      return false;
    }
    await requestBackgroundPermission();
    return await _makeCall();
  }

  Future<Uint8List?> captureFrame() async {
    if (localStream != null) {
      final track = localStream!.getVideoTracks().first;
      final frame = await track.captureFrame();
      return frame.asUint8List();
    }
    return null;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<bool> _makeCall([DesktopCapturerSource? source]) async {
    Log.d('_makeCall');
    try {
      var stream = await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
        'video': source == null
            ? true
            : {
          'deviceId': {'exact': source.id},
          'mandatory': {'frameRate': 30.0}
        }
      });
      stream.getVideoTracks()[0].onEnded = () {
        Log.d('By adding a listener on onEnded you can: 1) catch stop video sharing on Web');
      };

      localStream = stream;
      localRenderer.srcObject = localStream;
    } catch (e) {
      Log.e(e.toString());
    }
    // if (!mounted) return;
    inCalling.value = true;
    return inCalling.value;
  }

  Future<void> _stop() async {
    try {
      if (kIsWeb) {
        localStream?.getTracks().forEach((track) => track.stop());
      }
      await localStream?.dispose();
      localStream = null;
      localRenderer.srcObject = null;
    } catch (e) {
      Log.e(e.toString());
    }
  }

  Future<bool> stopScreenShare() async {
    await _stop();
    inCalling.value = false;
    return inCalling.value;
  }
  
}

class ScreenSharePage extends GetView<ScreenShareController> {
  
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<ScreenShareController>(() => ScreenShareController());
    return Obx(() => controller.inCalling.value ? Container(
      margin: EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(color: Colors.black54),
      child: RTCVideoView(controller.localRenderer),
    ) : SizedBox());
  }
}
