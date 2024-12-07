import 'package:flutter/material.dart';
import 'package:trip_flutter/dao/home_dao.dart';
import 'package:trip_flutter/model/home_model.dart';
import 'package:trip_flutter/pages/search_page.dart';
import 'package:trip_flutter/util/navigator_util.dart';
import 'package:trip_flutter/widget/loading_container.dart';
import 'package:trip_flutter/widget/local_nav_widget.dart';
import 'package:trip_flutter/widget/sales_box_widget.dart';
import 'package:trip_flutter/widget/search_bar_widget.dart';
import 'package:trip_flutter/widget/sub_nav_widget.dart';

import '../dao/login_dao.dart';
import '../util/view_util.dart';
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
  String appBarDefaultText = "网红打卡景点 美食 电影";

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

  get _jumpToSearch => () {
        NavigatorUtil.push(context, const SearchPage());
      };

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

  get _appBar {
    double top = MediaQuery.of(context).padding.top;
    return Column(children: [
      shadowWrap(
          child: Container(
              padding: EdgeInsets.only(top: top),
              height: 60 + top,
              decoration: BoxDecoration(
                  color: Color.fromARGB(
                      (appBarAlpha * 255).toInt(), 255, 255, 255)),
              child: SearchBarWidget(
                searchBarType: appBarAlpha > 0.2
                    ? SearchBarType.homeLight
                    : SearchBarType.homeLight,
                inputBoxClick: _jumpToSearch,
                defaultText: appBarDefaultText,
                rightButtonClick: () {
                  LoginDao.logout();
                },
              ))),
      Container(
        height: appBarAlpha > 0.2 ? 0.5 : 0,
        decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
      )
    ]);
  }

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
