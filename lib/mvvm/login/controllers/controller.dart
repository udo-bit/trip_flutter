import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:trip_flutter/dao/login_dao.dart';
import 'package:trip_flutter/util/navigator_util.dart';
import 'package:url_launcher/url_launcher.dart';

enum LoginInputType { username, password }

class LoginViewModel extends GetxController {
  final loginEnable = false.obs;
  String? username;
  String? password;

  void onValueChanged(String value, LoginInputType type) {
    if (type == LoginInputType.username) {
      username = value;
    } else {
      password = value;
    }
    loginEnable(username != null &&
        username!.isNotEmpty &&
        password != null &&
        password!.isNotEmpty);
  }

  login() async {
    try {
      var result =
          await LoginDao.login(username: username!, password: password!);
      NavigatorUtil.goToHome();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void jumpToRegister() async {
    var uri = Uri.parse(
        'https://api.devio.org/uapi/swagger-ui.html#/Account/registrationUsingPOST');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }
}
