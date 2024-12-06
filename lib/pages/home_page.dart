import 'package:flutter/material.dart';
import 'package:trip_flutter/dao/home_dao.dart';
import 'package:trip_flutter/model/home_model.dart';
import 'package:trip_flutter/widget/loading_container.dart';
import 'package:trip_flutter/widget/local_nav_widget.dart';
import 'package:trip_flutter/widget/sales_box_widget.dart';
import 'package:trip_flutter/widget/sub_nav_widget.dart';

import '../dao/login_dao.dart';
import '../widget/banner_widget.dart';
import '../widget/grid_nav_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static Config? configModel;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  double appBarAlpha = 0;
  static const appBarScrollOffset = 100;

  List<CommonModel> bannerListModel = [];
  List<CommonModel> localNavListModel = [];
  List<CommonModel> subNavListModel = [];
  GridNav? gridNavModel;
  SalesBox? salesBoxModel;

  bool _loading = true;

  get _contentView => MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: RefreshIndicator(
        color: Colors.blue,
        onRefresh: _handleRefresh,
        child: NotificationListener(
          onNotification: (notification) {
            if (notification is ScrollNotification && notification.depth == 0) {
              _onScroll(notification.metrics.pixels);
            }
            return false;
          },
          child: _listView,
        ),
      ));

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  get _logoutBtn => ElevatedButton(
      onPressed: () {
        LoginDao.logout();
      },
      child: const Text("登出"));

  get _appBar => Opacity(
      opacity: appBarAlpha,
      child: Container(
        height: 80,
        decoration: const BoxDecoration(color: Colors.white),
        child: const Center(
          child: Padding(padding: EdgeInsets.only(top: 20), child: Text("首页")),
        ),
      ));

  get _listView => ListView(
        children: [
          BannerWidget(bannerListModel),
          LocalNavWidget(localNavList: localNavListModel),
          if (gridNavModel != null)
            GridNavWidget(
              gridNav: gridNavModel!,
            ),
          SubNavWidget(subNavList: subNavListModel),
          if (salesBoxModel != null) SalesBoxWidget(salesBox: salesBoxModel!),
          // _logoutBtn,
          // const SizedBox(
          //   height: 800,
          //   child: ListTile(title: Text("哈哈")),
          // )
        ],
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        body: LoadingContainer(
          isLoading: _loading,
          child: Stack(
            children: [_contentView, _appBar],
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;

  void _onScroll(double pixels) {
    double alpha = pixels / appBarScrollOffset;
    if (alpha < 0) {
      alpha = 0.0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  Future<void> _handleRefresh() async {
    try {
      HomeModel homeModel = await HomeDao.fetch();
      debugPrint(homeModel.bannerList.toString());
      setState(() {
        HomePage.configModel = homeModel.config;
        bannerListModel = homeModel.bannerList ?? [];
        localNavListModel = homeModel.localNavList ?? [];
        subNavListModel = homeModel.subNavList ?? [];
        gridNavModel = homeModel.gridNav;
        salesBoxModel = homeModel.salesBox;
        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _loading = false;
      });
    }
  }
}
