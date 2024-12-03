import 'package:flutter/material.dart';
import 'package:trip_flutter/dao/login_dao.dart';
import 'package:trip_flutter/util/navigator_util.dart';
import 'package:trip_flutter/widget/input_widget.dart';
import 'package:trip_flutter/widget/login_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/string_util.dart';
import '../util/view_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool btnEnable = false;
  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [..._background(), _content()]));
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
                username = text;
                validCheck();
              },
            ),
            hiSpace(height: 10),
            InputWidget(
              "请输入密码",
              keyboardType: TextInputType.number,
              obscureText: true,
              onChanged: (text) {
                password = text;
                validCheck();
              },
            ),
            hiSpace(height: 10),
            LoginWidget(
              "登陆",
              enable: btnEnable,
              onPressed: () => _login(context),
            ),
            hiSpace(height: 10),
            Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: _jumpToRegister,
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

  void validCheck() {
    bool btnState = false;
    if (isNotEmpty(username) && isNotEmpty(password)) {
      btnState = true;
    } else {
      btnState = false;
    }
    setState(() {
      btnEnable = btnState;
    });
  }

  _login(context) async {
    await LoginDao.login(username: username!, password: password!);
    NavigatorUtil.goToHome(context);
  }

  void _jumpToRegister() async {
    var uri = Uri.parse(
        'https://api.devio.org/uapi/swagger-ui.html#/Account/registrationUsingPOST');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }
}
