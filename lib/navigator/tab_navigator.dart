import 'package:flutter/material.dart';
import 'package:trip_flutter/pages/home_page.dart';
import 'package:trip_flutter/pages/my_page.dart';
import 'package:trip_flutter/pages/search_page.dart';
import 'package:trip_flutter/pages/travel_page.dart';
import 'package:trip_flutter/util/navigator_util.dart';

class TabNavigator extends StatefulWidget {
  const TabNavigator({super.key});

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentIndex = 0;
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    NavigatorUtil.updateContext(context);
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        controller: _controller,
        // physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(),
          SearchPage(
            hideLeft: true,
            keyword: '北京',
          ),
          TravelPage(),
          MyPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            _bottomItem("首页", Icons.home, 0),
            _bottomItem("搜索", Icons.search, 1),
            _bottomItem("旅拍", Icons.camera_alt, 2),
            _bottomItem("我的", Icons.account_circle, 3)
          ]),
    );
  }

  _bottomItem(String title, IconData iconData, int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          iconData,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          iconData,
          color: _activeColor,
        ),
        label: title);
  }
}
