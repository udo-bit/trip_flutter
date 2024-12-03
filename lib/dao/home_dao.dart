import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trip_flutter/dao/header_util.dart';
import 'package:trip_flutter/model/home_model.dart';
import 'package:trip_flutter/util/navigator_util.dart';

class HomeDao {
  static Future<HomeModel> fetch() async {
    var uri = Uri.parse('http://api.geekailab.com/uapi/ft/home');

    var response = await http.get(uri, headers: hiHeader());
    Utf8Decoder utf8decoder = const Utf8Decoder();
    String bodyString = utf8decoder.convert(response.bodyBytes);
    if (response.statusCode == 200) {
      var map = json.decode(bodyString);
      return HomeModel.fromJson(map['data']);
    } else {
      if (response.statusCode == 401) {
        NavigatorUtil.goToLogin();
      }
      throw Exception(bodyString);
    }
  }
}
