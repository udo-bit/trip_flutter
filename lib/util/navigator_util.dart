import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trip_flutter/navigator/tab_navigator.dart';
import 'package:trip_flutter/pages/login_page.dart';
import 'package:trip_flutter/widget/hi_webview.dart';

class NavigatorUtil {
  static BuildContext? _context;
  static updateContext(BuildContext context) {
    _context = context;
  }

  // 跳转到指定页面
  static push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  // 跳转首页
  static goToHome(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const TabNavigator()));
  }

  // 跳转到登陆页
  static goToLogin() {
    Navigator.pushReplacement(
        _context!, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  static pop(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      //退出APP
      SystemNavigator.pop();
    }
  }

  static jumpH5(
      {BuildContext? context,
      String? url,
      String? title,
      bool? hideAppBar,
      String? statusBarColor}) {
    BuildContext? safeContext;
    if (url == null) {
      debugPrint('url is null jumpH5 failed');
      return;
    }
    if (context != null) {
      safeContext = context;
    } else if (_context?.mounted ?? false) {
      safeContext = _context;
    } else {
      debugPrint('context is null jumpH5 failed.');
      return;
    }
    Navigator.push(
        safeContext!,
        MaterialPageRoute(
            builder: (context) => HiWebView(
                  url: url,
                  hideAppBar: hideAppBar,
                  title: title,
                  statusBarColor: statusBarColor,
                )));
  }
}
