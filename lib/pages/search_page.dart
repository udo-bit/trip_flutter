import 'package:flutter/material.dart';
import 'package:trip_flutter/dao/search_dao.dart';
import 'package:trip_flutter/model/search_model.dart';
import 'package:trip_flutter/util/navigator_util.dart';
import 'package:trip_flutter/util/view_util.dart';
import 'package:trip_flutter/widget/search_bar_widget.dart';
import 'package:trip_flutter/widget/search_item_widget.dart';

class SearchPage extends StatefulWidget {
  final String? hint;
  final String? keyword;
  final bool? hideLeft;

  const SearchPage({super.key, this.hint, this.keyword, this.hideLeft = false});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel? searchModel;

  @override
  void initState() {
    super.initState();
    if (widget.keyword != null) {
      _onTextChange(widget.keyword!);
    }
  }

  get _appBar {
    double top = MediaQuery.of(context).padding.top;
    return shadowWrap(
        child: Container(
          height: 55 + top,
          decoration: const BoxDecoration(color: Colors.white),
          padding: EdgeInsets.only(top: top),
          child: SearchBarWidget(
            hideLeft: widget.hideLeft,
            defaultText: widget.keyword,
            hint: widget.hint,
            leftButtonClick: () => NavigatorUtil.pop(context),
            rightButtonClick: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            onChanged: _onTextChange,
          ),
        ),
        padding: const EdgeInsets.only(bottom: 5));
  }

  get _listView => MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Expanded(
          child: ListView.builder(
              itemCount: searchModel?.data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return _item(index);
              }),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [_appBar, _listView],
    ));
  }

  void _onTextChange(String value) async {
    try {
      var result = await SearchDao.fetch(value);
      if (result == null) return;
      if (result.keyword == value) {
        setState(() {
          searchModel = result;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget _item(int index) {
    var item = searchModel?.data?[index];
    if (item == null) return Container();
    return SearchItemWidget(
      searchItem: item,
      searchModel: searchModel!,
    );
  }
}
