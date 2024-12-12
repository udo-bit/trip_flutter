import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_flutter/controller/travel_controller.dart';
import 'package:trip_flutter/model/travel_category_model.dart';
import 'package:trip_flutter/pages/travel_tab_page.dart';
import 'package:underline_indicator/underline_indicator.dart';

class TravelPage extends StatelessWidget {
  const TravelPage({super.key});

  get _tabBar {
    return GetBuilder<TravelController>(builder: (TravelController controller) {
      return TabBar(
          controller: controller.controller,
          isScrollable: true,
          // 设置指示器左侧对齐
          tabAlignment: TabAlignment.start,
          // 设置指示器宽度
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.black,
          indicator: const UnderlineIndicator(
              strokeCap: StrokeCap.round,
              borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3),
              insets: EdgeInsets.only(bottom: 0)),
          tabs: controller.tabs.map<Tab>((TravelTab tab) {
            return Tab(
              text: tab.labelName,
            );
          }).toList());
    });
  }

  get _tabBarView =>
      GetBuilder<TravelController>(builder: (TravelController controller) {
        return TabBarView(
            controller: controller.controller,
            children: controller.tabs.map((TravelTab tab) {
              return TravelTabPage(groupChannelCode: tab.groupChannelCode);
            }).toList());
      });

  @override
  Widget build(BuildContext context) {
    // controller初始化
    Get.put(TravelController());
    double top = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: top),
            child: _tabBar,
          ),
          Flexible(child: _tabBarView)
        ],
      ),
    );
  }
}
