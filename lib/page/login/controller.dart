import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../common/store/store.dart';

class LoginController extends GetxController {
  login(TextEditingController userIdController, TextEditingController userNameController) async {
    var userId = userIdController.text;
    var userName = userNameController.text;

    if (userId.isEmpty) {
      Fluttertoast.showToast(msg: '您输入的userId为空');
      return;
    }

    if (userName.isEmpty) {
      userName = userId;
    }

    UserStore.to.setUserId(userId);
  }
}
