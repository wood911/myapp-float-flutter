import 'package:get/get.dart';
import 'package:volume_control/volume_control.dart';

import '../../common/utils/logger.dart';

class VolumeController extends GetxController {
  var volume = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  onChanged(double val) async {
    volume.value = (val * 100).toInt();
  }

  onComplete(double val) async {
    Log.d('onComplete $val');
    await VolumeControl.setVolume(val);
  }
}
