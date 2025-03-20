import 'package:get/get.dart';
import 'package:myapp/page/home/bindings.dart';
import 'package:myapp/page/home/view.dart';
import 'package:myapp/page/recording/capture_frame_sample.dart';
import 'package:myapp/page/recording/device_enumeration_sample.dart';
import 'package:myapp/page/recording/get_display_media_sample.dart';
import 'package:myapp/page/recording/get_user_media_sample.dart';
import 'package:myapp/page/recording/loopback_data_channel_sample.dart';
import 'package:myapp/page/recording/loopback_sample_unified_tracks.dart';

import '../../page/login/bindings.dart';
import '../../page/login/view.dart';
import 'routes.dart';

class AppPages {
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: AppRoutes.captureFrame,
      page: () => CaptureFrameSample(),
    ),
    GetPage(
      name: AppRoutes.deviceEnum,
      page: () => DeviceEnumerationSample(),
    ),
    GetPage(
      name: AppRoutes.displayMedia,
      page: () => GetDisplayMediaSample(),
    ),
    GetPage(
      name: AppRoutes.getUserMedia,
      page: () => GetUserMediaSample(),
    ),
    GetPage(
      name: AppRoutes.loopbackChannel,
      page: () => DataChannelLoopBackSample(),
    ),
    GetPage(
      name: AppRoutes.loopbackTracks,
      page: () => LoopBackSampleUnifiedTracks(),
    ),
  ];
}
