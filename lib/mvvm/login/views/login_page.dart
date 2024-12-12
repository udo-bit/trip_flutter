import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_flutter/mvvm/login/controllers/controller.dart';
import 'package:trip_flutter/widget/input_widget.dart';
import 'package:trip_flutter/widget/login_widget.dart';

import '../../../util/view_util.dart';

class LoginPage extends GetView<LoginViewModel> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [..._background(), Obx(() => _content())]));
  }

  _background() {
    return [
      Positioned.fill(
        child: Image.asset(
          "images/login-bg1.png",
          fit: BoxFit.cover,
        ),
      ),
      Positioned.fill(
          child: Container(
        decoration: const BoxDecoration(color: Colors.black54),
      ))
    ];
  }

  _content() {
    return Positioned.fill(
        left: 25,
        right: 25,
        child: ListView(
          children: [
            hiSpace(height: 100),
            const Text(
              "账号密码登陆",
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
            hiSpace(height: 40),
            InputWidget(
              "请输入用户名",
              keyboardType: TextInputType.text,
              onChanged: (text) {
                controller.onValueChanged(text, LoginInputType.username);
              },
            ),
            hiSpace(height: 10),
            InputWidget(
              "请输入密码",
              keyboardType: TextInputType.number,
              obscureText: true,
              onChanged: (text) {
                controller.onValueChanged(text, LoginInputType.password);
              },
            ),
            hiSpace(height: 10),
            LoginWidget("登陆",
                enable: controller.loginEnable.value,
                onPressed: () => controller.login()),
            hiSpace(height: 10),
            Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: controller.jumpToRegister,
                  child: const Text(
                    "注册用户",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ))
          ],
        ));
  }
}
