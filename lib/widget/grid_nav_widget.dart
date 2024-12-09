import 'package:flutter/material.dart';
import 'package:trip_flutter/util/navigator_util.dart';

import '../model/home_model.dart';

class GridNavWidget extends StatelessWidget {
  final GridNav gridNav;
  const GridNavWidget({super.key, required this.gridNav});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
      child: PhysicalModel(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: _gridNavItems(context),
          )),
    );
  }

  _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    items.add(_gridNavItem(context, gridNav.hotel!, true));
    items.add(_gridNavItem(context, gridNav.flight!, false));
    items.add(_gridNavItem(context, gridNav.travel!, false));
    return items;
  }

  Widget _gridNavItem(BuildContext context, Hotel gridNavItem, bool first) {
    List<Widget> items = [];
    items.add(_mainItem(context, gridNavItem.mainItem!));
    items.add(_doubleItem(context, gridNavItem.item1!, gridNavItem.item2!));
    items.add(_doubleItem(context, gridNavItem.item3!, gridNavItem.item4!));

    List<Widget> expandItems = [];
    for (var item in items) {
      expandItems.add(Expanded(flex: 1, child: item));
    }
    Color startColor = Color(int.parse('0xff${gridNavItem.startColor}'));
    Color endColor = Color(int.parse('0xff${gridNavItem.endColor}'));
    return Container(
      height: 88,
      margin: first ? null : const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [startColor, endColor])),
      child: Row(
        children: expandItems,
      ),
    );
  }

  Widget _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(
        context,
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Image.network(
              model.icon!,
              fit: BoxFit.contain,
            ),
            Container(
              margin: const EdgeInsets.only(top: 11),
              child: Text(model.title!,
                  style: const TextStyle(fontSize: 14, color: Colors.white)),
            )
          ],
        ),
        model);
  }

  Widget _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
        onTap: () {
          NavigatorUtil.jumpH5(
              url: model.url,
              title: model.title,
              statusBarColor: model.statusBarColor,
              hideAppBar: model.hideAppBar);
        },
        child: widget);
  }

  Widget _doubleItem(
      BuildContext context, CommonModel topItem, CommonModel bottomItem) {
    return Column(
      children: [
        Expanded(child: _item(context, topItem, true)),
        Expanded(child: _item(context, bottomItem, false))
      ],
    );
  }

  _item(BuildContext context, CommonModel item, bool first) {
    BorderSide borderSide = const BorderSide(width: 0.8, color: Colors.white);
    return Container(
      decoration: BoxDecoration(
          border: Border(
              left: borderSide, bottom: first ? borderSide : BorderSide.none)),
      child: _wrapGesture(
          context,
          Center(
            child: Text(item.title!,
                style: const TextStyle(fontSize: 14, color: Colors.white)),
          ),
          item),
    );
  }
}
