import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:trip_flutter/dao/travel_dao.dart';
import 'package:trip_flutter/widget/loading_container.dart';
import 'package:trip_flutter/widget/travel_item_widget.dart';

import '../model/travel_tab_model.dart';

class TravelTabPage extends StatefulWidget {
  final String groupChannelCode;

  const TravelTabPage({super.key, required this.groupChannelCode});

  @override
  State<TravelTabPage> createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();

  List<TravelItem> travelItems = [];
  int pageIndex = 1;
  bool _loading = true;

  get _gridView => MasonryGridView.count(
        itemCount: travelItems.length,
        controller: _controller,
        crossAxisCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return TravelItemWidget(item: travelItems[index]);
        },
      );

  @override
  void initState() {
    _loadData();
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: LoadingContainer(
            isLoading: _loading,
            child: RefreshIndicator(
                color: Colors.blue,
                onRefresh: _loadData,
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: _gridView,
                ))));
  }

  Future<void> _loadData({loadMore = false}) async {
    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    try {
      TravelTabModel? model =
          await TravelDao.getTravels(widget.groupChannelCode, pageIndex, 10);
      List<TravelItem> items = _filterItems(model?.list);
      if (items.isEmpty) {
        pageIndex--;
      }
      setState(() {
        _loading = false;
        if (loadMore) {
          travelItems.addAll(items);
        } else {
          travelItems = items;
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      _loading = false;
      if (loadMore) {
        pageIndex--;
      }
    }
  }

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

  @override
  bool get wantKeepAlive => true;
}
