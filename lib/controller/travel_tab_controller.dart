import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../dao/travel_dao.dart';
import '../model/travel_tab_model.dart';

class TravelController extends GetxController {
  final String groupChannelCode;

  TravelController(this.groupChannelCode);
  List<TravelItem> travelItems = <TravelItem>[].obs;
  final loading = true.obs;
  int pageIndex = 1;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadData(loadMore: true);
      }
    });
  }

  @override
  onClose() {
    scrollController.dispose();
  }

  Future<void> loadData({loadMore = false}) async {
    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    try {
      TravelTabModel? model =
          await TravelDao.getTravels(groupChannelCode, pageIndex, 10);
      List<TravelItem> items = _filterItems(model?.list);
      if (items.isEmpty) {
        pageIndex--;
      }
      loading.value = false;
      if (!loadMore) {
        travelItems.clear();
      }
      travelItems.addAll(items);
    } catch (e) {
      debugPrint(e.toString());
      loading.value = false;
      if (loadMore) {
        pageIndex--;
      }
    }
  }

  ///移除article为空的模型
  List<TravelItem> _filterItems(List<TravelItem>? list) {
    if (list == null) return [];
    List<TravelItem> filterItems = [];
    for (var item in list) {
      if (item.article != null) {
        filterItems.add(item);
      }
    }
    return filterItems;
  }
}
