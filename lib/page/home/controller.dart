import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_accessibility_service/constants.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/routers/routes.dart';
import '../../common/utils/logger.dart';
import '../../common/values/values.dart';
import '../recording/screen_share.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final _receivePort = ReceivePort();
  SendPort? homePort;
  var messageFromOverlay = ''.obs;
  /// resumed	应用回到前台，可以正常交互	继续播放视频、恢复数据同步
  /// inactive	短暂失去焦点，但可能仍然可见	iOS: 接听电话/多任务切换
  /// paused	应用进入后台，不可见	停止动画、暂停音乐
  /// detached	应用即将被销毁，但仍占用资源	清理资源，释放内存
  AppLifecycleState appState = AppLifecycleState.resumed;
  bool get foreground => [AppLifecycleState.resumed, AppLifecycleState.inactive].contains(appState);

  final options = {
    'captureFrame'.tr: AppRoutes.captureFrame,
    'deviceEnum'.tr: AppRoutes.deviceEnum,
    'displayMedia'.tr: AppRoutes.displayMedia,
    'getUserMedia'.tr: AppRoutes.getUserMedia,
    'loopbackChannel'.tr: AppRoutes.loopbackChannel,
    'loopbackTracks'.tr: AppRoutes.loopbackTracks,
    'streamVideo'.tr: AppRoutes.streamVideoHome,
  };

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    FlutterOverlayWindow.overlayListener.listen((event) {
      Log.d("overlayListener:$event");
    });
    _initPort();
    Get.put<ScreenShareController>(ScreenShareController());
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  _initPort() {
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      Values.kPortNameHome,
    );
    _receivePort.listen((message) {
      messageFromOverlay.value = message.toString();
      Log.d("message from overlay: $message");
      final cmd = message[Values.cmdOverlayKey] ?? '';
      if (cmd == Values.cmdCloseOverlay) {
        FlutterOverlayWindow.closeOverlay();
      } else if (cmd == Values.cmdResizeOverlay) {
        FlutterOverlayWindow.resizeOverlay(message['width'], message['height'], false);
      } else if (cmd == Values.cmdScreenShare) {
        _screenShare();
      } else if (cmd == Values.cmdSaveImage) {
        if (message['image'] is Uint8List) {
          _saveImage(message['image']);
        }
      } else if (cmd == Values.cmdScreenshot) {
        _takeScreenshot();
      } else if (cmd == Values.cmdGoBack) {
        foreground
            ? MoveToBackground.moveTaskToBack()
            : MoveToBackground.bringAppToFront();
      } else if (cmd == Values.cmdSwitchTask) {
        _cmdAccessibility(GlobalAction.globalActionRecents);
      }
    });
  }

  _cmdAccessibility(GlobalAction action) async {
    bool status = await FlutterAccessibilityService.isAccessibilityPermissionEnabled();
    if (!status) {
      status = await FlutterAccessibilityService.requestAccessibilityPermission();
    }
    if (status) {
      await FlutterAccessibilityService.performGlobalAction(action);
    }
  }
  _screenShare() async {
    if (!foreground) {
      Log.w('Android 11 及以上 的新安全限制，导致应用不能在后台直接请求权限。');
      MoveToBackground.bringAppToFront();
      await Future.delayed(const Duration(milliseconds: 500));
    }
    final ScreenShareController controller = Get.find();
    bool res = controller.inCalling.value
        ? await controller.stopScreenShare()
        : await controller.startScreenShare();
    _syncRecordStatus(res);
  }
  _takeScreenshot() async {
    if (foreground) {
      // 应用在前台用native screenshot
      _nativeScreenshot();
    } else {
      // 应用在后台，无法请求权限，无法截图，需要通过AccessibilityService
      _cmdAccessibility(GlobalAction.globalActionTakeScreenshot);
    }
  }
  _nativeScreenshot() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.storage,
    ].request();
    List<bool> list = [];
    statuses.forEach((_, status) => list.add(status.isGranted));
    if (list.where((e) => e == true).length != statuses.length) {
      Fluttertoast.showToast(msg: '请打开访问相册、外部存储的权限'.tr);
    }
    String? path = await FlutterNativeScreenshot.takeScreenshot();
    if (path != null && path.isNotEmpty) {
      final data = File(path).readAsBytesSync();
      _saveImage(data);
    } else {
      Log.e('native screenshot fail:$path');
    }
  }

  _saveImage(Uint8List data) async {
    var status = await Permission.photos.request();
    if (!status.isGranted) {
      Fluttertoast.showToast(msg: '请打开访问相册的权限'.tr);
      return;
    }
    final result = await ImageGallerySaverPlus.saveImage(data, quality: 100);
    Log.d(result);
    Fluttertoast.showToast(msg: '已保存至相册'.tr);
  }

  _syncRecordStatus(res) {
    sendMsg({
      Values.cmdOverlayKey: Values.cmdRecordStatus,
      'status': res,
    });
  }

  requestPermission() async {
    final permissions = [
      Permission.photos,
      Permission.microphone,
      Permission.camera,
      Permission.location,
      Permission.storage,
    ];
    if (GetPlatform.isIOS) {
      permissions.addAll([
        Permission.bluetooth,
      ]);
    } else if (GetPlatform.isAndroid) {
      permissions.addAll([
        Permission.bluetoothConnect,
        Permission.mediaLibrary,
        Permission.systemAlertWindow,
      ]);
    }
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    List<bool> list = [];
    statuses.forEach((_, status) => list.add(status.isGranted));
    Log.d(statuses);
    if (list.where((e) => e == true).length != statuses.length) {
      Fluttertoast.showToast(msg: '请打开访问相机、相册、麦克风、蓝牙等权限'.tr);
    }
  }

  createOverlay([int? width, int? height]) async {
    final status = await FlutterOverlayWindow.isPermissionGranted();
    Log.d("FlutterOverlayWindow Permission Granted: $status");
    if (!status) {
      bool? res = await FlutterOverlayWindow.requestPermission();
      if (res != true) {
        Fluttertoast.showToast(msg: '请运行悬浮窗口权限'.tr);
        return;
      }
    }
    if (await FlutterOverlayWindow.isActive()) {
      FlutterOverlayWindow.closeOverlay();
    } else {
      await FlutterOverlayWindow.showOverlay(
        alignment: OverlayAlignment.centerRight,
        enableDrag: false,
        overlayTitle: "悬浮窗口",
        overlayContent: 'Overlay Enabled',
        flag: OverlayFlag.focusPointer,
        visibility: NotificationVisibility.visibilityPublic,
        positionGravity: PositionGravity.auto,
        width: width ?? (50 * Get.pixelRatio).toInt(),
        height: height ?? (50 * Values.menuCount * Get.pixelRatio).toInt(),
        startPosition: OverlayPosition(0, 0),
      );
    }
  }

  sendMsg(Object data) {
    homePort ??=
        IsolateNameServer.lookupPortByName(Values.kPortNameOverlay);
    homePort?.send(data);
  }
  getPosition() {
    FlutterOverlayWindow.getOverlayPosition().then((value) {
      Log.d('Overlay Position: $value');
      messageFromOverlay.value = 'Overlay Position: $value';
    });
  }

  void jump(int tag) {
    Get.toNamed(options.values.elementAt(tag));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appState = state;
  }
}
