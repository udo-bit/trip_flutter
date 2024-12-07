import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trip_flutter/dao/header_util.dart';
import 'package:trip_flutter/util/navigator_util.dart';

import '../model/search_model.dart';

class SearchDao {
  static Future<SearchModel?> fetch(String text) async {
    var uri = Uri.parse('http://api.geekailab.com/uapi/ft/search?q=$text');
    var response = await http.get(uri, headers: hiHeader());
    Utf8Decoder utf8decoder = const Utf8Decoder();
    var bodyString = utf8decoder.convert(response.bodyBytes);
    if (response.statusCode == 200) {
      var map = json.decode(bodyString);
      var model = SearchModel.fromJson(map);
      model.keyword = text;
      return model;
    } else {
      if (response.statusCode == 401) {
        NavigatorUtil.goToLogin();
        return null;
      } else {
        throw Exception(bodyString);
      }
    }
  }
}
