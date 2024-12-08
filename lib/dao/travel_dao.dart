import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trip_flutter/dao/header_util.dart';
import 'package:trip_flutter/model/travel_category_model.dart';
import 'package:trip_flutter/util/navigator_util.dart';

import '../model/travel_tab_model.dart';

class TravelDao {
  static Future<TravelCategoryModel?> getCategory() async {
    var uri = Uri.parse('http://api.geekailab.com/uapi/ft/category');
    var response = await http.get(uri, headers: hiHeader());
    Utf8Decoder utf8decoder = const Utf8Decoder();
    var bodyString = utf8decoder.convert(response.bodyBytes);
    if (response.statusCode == 200) {
      var map = json.decode(bodyString);
      return TravelCategoryModel.fromJson(map['data']);
    } else {
      if (response.statusCode == 401) {
        NavigatorUtil.goToLogin();
        return null;
      } else {
        throw Exception(bodyString);
      }
    }
  }

  static Future<TravelTabModel?> getTravels(
      String groupChannelCode, int pageIndex, int pageSize) async {
    Map<String, String> paramsMap = {};
    paramsMap['pageIndex'] = pageIndex.toString();
    paramsMap['pageSize'] = pageSize.toString();
    paramsMap['groupChannelCode'] = groupChannelCode;
    var uri = Uri.http('api.geekailab.com', '/uapi/ft/travels', paramsMap);
    var response = await http.get(uri, headers: hiHeader());
    Utf8Decoder utf8decoder = const Utf8Decoder();
    var bodyString = utf8decoder.convert(response.bodyBytes);
    if (response.statusCode == 200) {
      var result = json.decode(bodyString);
      return TravelTabModel.fromJson(result['data']);
    } else {
      if (response.statusCode == 401) {
        NavigatorUtil.goToLogin();
        return null;
      }
      throw Exception(bodyString);
    }
  }
}
