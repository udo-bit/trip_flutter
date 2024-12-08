import 'package:flutter/material.dart';
import 'package:trip_flutter/dao/travel_dao.dart';
import 'package:trip_flutter/model/travel_category_model.dart';
import 'package:trip_flutter/pages/travel_tab_page.dart';
import 'package:underline_indicator/underline_indicator.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({super.key});

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin {
  List<TravelTab> tabs = [];
  TravelCategoryModel? travelCategoryModel;
  late TabController _controller;

  get _tabBar {
    return TabBar(
        controller: _controller,
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
        tabs: tabs.map<Tab>((TravelTab tab) {
          return Tab(
            text: tab.labelName,
          );
        }).toList());
  }

  get _tabBarView => TabBarView(
      controller: _controller,
      children: tabs.map((TravelTab tab) {
        return TravelTabPage(groupChannelCode: tab.groupChannelCode);
      }).toList());

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 0, vsync: this);
    TravelDao.getCategory().then((TravelCategoryModel? model) {
      _controller = TabController(length: model?.tabs.length ?? 0, vsync: this);
      setState(() {
        tabs = model?.tabs ?? [];
        travelCategoryModel = model;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
