import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:trip_flutter/controller/travel_tab_controller.dart';
import 'package:trip_flutter/widget/loading_container.dart';
import 'package:trip_flutter/widget/travel_item_widget.dart';

class TravelTabPage extends StatefulWidget {
  final String groupChannelCode;

  const TravelTabPage({super.key, required this.groupChannelCode});

  @override
  State<TravelTabPage> createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage>
    with AutomaticKeepAliveClientMixin {
  late TravelController travelController;

  get _gridView => MasonryGridView.count(
        itemCount: travelController.travelItems.length,
        controller: travelController.scrollController,
        crossAxisCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return TravelItemWidget(item: travelController.travelItems[index]);
        },
      );

  get _obx => Obx(() => LoadingContainer(
      isLoading: travelController.loading.value,
      child: RefreshIndicator(
          color: Colors.blue,
          onRefresh: _handleRefresh,
          child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: _gridView,
          ))));

  // get _getx => GetX<TravelController>(
  //       builder: (controller) {
  //         return LoadingContainer(
  //             isLoading: travelController.loading.value,
  //             child: RefreshIndicator(
  //                 color: Colors.blue,
  //                 onRefresh: _handleRefresh,
  //                 child: MediaQuery.removePadding(
  //                   removeTop: true,
  //                   context: context,
  //                   child: _gridView,
  //                 )));
  //       },
  //       init: travelController,
  //     );

  @override
  void initState() {
    super.initState();
    travelController = Get.put(TravelController(widget.groupChannelCode),
        tag: widget.groupChannelCode);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(body: _obx);
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _handleRefresh() async {
    await travelController.loadData();
    return;
  }
}
