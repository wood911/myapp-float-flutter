import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/values/colors.dart';
import 'controller.dart';

class LoginPage extends GetView<LoginController> {
  final userIdController = TextEditingController();
  final userNameController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.primaryBackground,
        body: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildUserIdInputWidget(userIdController),
              const SizedBox(height: 24),
              buildUserNameInputWidget(userNameController),
              const SizedBox(height: 24),
              buildLoginButton(),
            ],
          ),
        ));
  }

  Widget buildUserIdInputWidget(TextEditingController? userIdController) {
    return TextField(
      controller: userIdController,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: const BorderSide(color: Colors.white, width: 0.5)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: const BorderSide(color: Colors.white, width: 0.5)),
          labelText: "userId:",
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: const BorderSide(color: Colors.white))),
      style: const TextStyle(fontSize: 16, color: Colors.white),
    );
  }

  Widget buildUserNameInputWidget(TextEditingController? userNameController) {
    return TextField(
      controller: userNameController,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: const BorderSide(color: Colors.white, width: 0.5)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: const BorderSide(color: Colors.white, width: 0.5)),
          labelText: "userName".tr,
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: const BorderSide(color: Colors.white))),
      style: const TextStyle(fontSize: 16, color: Colors.white),
    );
  }

  Widget buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controller.login(userIdController, userNameController),
        style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(35))), padding: MaterialStateProperty.all(const EdgeInsets.all(16))),
        child: Text("login".tr),
      ),
    );
  }
}
