import 'package:get/get.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();
  final _isOpenCamera = false.obs;
  final _isOpenMicrophone = false.obs;
  final _userId = "".obs;
  final _isTakeSeat = false.obs;
  final _hasVideo = false.obs;
  final _hasAudio = false.obs;
  final _isFrontCamera = true.obs;

  get isFrontCamera => _isFrontCamera.value;

  set isFrontCamera(value) {
    _isFrontCamera.value = value;
  }

  bool get isOpenCamera => _isOpenCamera.value;

  bool get isOpenMicrophone => _isOpenMicrophone.value;

  bool get isTakeSeat => _isTakeSeat.value;

  bool get hasVideo => _hasVideo.value;

  bool get hasAudio => _hasAudio.value;

  String get userId => _userId.value;

  setUserId(String userId) {
    _userId.value = userId;
  }

  setIsOpenCamera(bool isOpen) {
    _isOpenCamera.value = isOpen;
  }

  setIsOpenMicrophone(bool isOpen) {
    _isOpenMicrophone.value = isOpen;
  }

  setIsTakeSeat(bool isTake) {
    _isTakeSeat.value = isTake;
  }

  setHasVideo(bool hasVideo) {
    _hasVideo.value = hasVideo;
  }

  setHasAudio(bool hasAudio) {
    _hasAudio.value = hasAudio;
  }
}
