import 'package:flutter/material.dart';
import 'package:trip_flutter/widget/banner_widget.dart';

import '../dao/login_dao.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  double appBarAlpha = 0;
  static const appBarScrollOffset = 100;

  final List<String> bannerList = [
    'https://gips3.baidu.com/it/u=1039279337,1441343044&fm=3028&app=3028&f=JPEG&fmt=auto&q=100&size=f1024_1024',
    'https://inews.gtimg.com/om_bt/O0e2a37GGF5CDfNgK8GU29rF_2eJlHLDsa17LABXns7V4AA/641',
    'https://img2.baidu.com/it/u=2822780089,1763663082&fm=253&fmt=auto&app=138&f=JPEG?w=1067&h=800',
    'https://pic.quanjing.com/kk/l0/QJ8669121073.jpg?x-oss-process=style/794ws',
    'https://wx1.sinaimg.cn/mw690/4ca91c90ly1hvbimemyeaj22c0340kjo.jpg',
  ];

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
          BannerWidget(bannerList),
          _logoutBtn,
          const SizedBox(
            height: 800,
            child: ListTile(title: Text("哈哈")),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Stack(
      children: [
        MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollNotification &&
                    notification.depth == 0) {
                  _onScroll(notification.metrics.pixels);
                }
                return false;
              },
              child: _listView,
            )),
        _appBar
      ],
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
}
