import 'package:flutter/material.dart';
import 'package:trip_flutter/model/home_model.dart';

class GridNavWidgetDemo extends StatelessWidget {
  final GridNav gridNav;
  const GridNavWidgetDemo({super.key, required this.gridNav});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
      child: PhysicalModel(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
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
    items.add(_double(context, gridNavItem.item1!, gridNavItem.item2!));
    items.add(_double(context, gridNavItem.item3!, gridNavItem.item4!));
    List<Widget> expandedItems = [];
    for (var item in items) {
      expandedItems.add(Expanded(
        flex: 1,
        child: item,
      ));
    }
    Color startColor = Color(int.parse('0xff${gridNavItem.startColor}'));
    Color endColor = Color(int.parse('0xff${gridNavItem.endColor}'));

    return Container(
      height: 88,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [startColor, endColor])),
      margin: first ? null : const EdgeInsets.only(top: 3),
      child: Row(
        children: expandedItems,
      ),
    );
  }

  Widget _mainItem(BuildContext context, CommonModel model) {
    return wrapGesture(
        context,
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Image.network(
              model.icon!,
              fit: BoxFit.contain,
            ),
            Text(model.title!,
                style: const TextStyle(fontSize: 14, color: Colors.white))
          ],
        ),
        model);
  }

  Widget wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      onTap: () {},
      child: widget,
    );
  }

  Widget _double(
      BuildContext context, CommonModel topItem, CommonModel bottomItem) {
    return Column(
      children: [
        Expanded(child: _item(context, topItem, true)),
        Expanded(child: _item(context, bottomItem, true)),
      ],
    );
  }

  _item(BuildContext context, CommonModel model, bool first) {
    BorderSide borderSide = const BorderSide(color: Colors.white, width: 0.8);
    return Container(
      decoration: BoxDecoration(
          border: Border(
              left: borderSide, bottom: first ? borderSide : BorderSide.none)),
      child: wrapGesture(
          context,
          Center(
            child: Text(
              model.title!,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          model),
    );
  }
}
