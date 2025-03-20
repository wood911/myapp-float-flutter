import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/values/colors.dart';

import '../recording/screen_share.dart';
import 'controller.dart';

class HomePage extends GetView<HomeController> {

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final list = [];
    for (int i = 0; i < controller.options.length; i++) {
      list.add(
        ElevatedButton(
          onPressed: () => controller.jump(i),
          child: Text(controller.options.keys.elementAt(i))
        )
      );
    }
    return Scaffold(
        appBar: AppBar(title: Text("浮动窗口")),
        backgroundColor: MyColors.primaryBackground,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              ElevatedButton(
                  onPressed: controller.requestPermission,
                  child: Text("请求权限".tr)
              ),
              ElevatedButton(
                  onPressed: controller.createOverlay,
                  child: Text("启动/关闭Overlay".tr)
              ),
              Text('''
               操作说明：
               1. 请求权限，允许所有权限，
                在App列表中逐个允许权限
               2. 启动/关闭Overlay
               3. 多任务android13+无权限
               4. 选择区域截图未实现
              '''),
              // ...list,
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: ScreenSharePage(),
              ),
            ],
          ),
        )
    );
  }

}

