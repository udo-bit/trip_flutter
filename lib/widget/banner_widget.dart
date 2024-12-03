import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trip_flutter/model/home_model.dart';
import 'package:trip_flutter/util/screen_helper.dart';

class BannerWidget extends StatefulWidget {
  final List<CommonModel> bannerList;
  const BannerWidget(this.bannerList, {super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CarouselSlider(
            carouselController: _controller,
            items: widget.bannerList
                .map((item) => _tabImage(item, width))
                .toList(),
            options: CarouselOptions(
                height: 200.px,
                autoPlay: true,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                })),
        Positioned(bottom: 10, left: 0, right: 0, child: _indicator())
      ],
    );
  }

  Widget _tabImage(CommonModel item, double width) {
    return GestureDetector(
      onTap: () {},
      child: Image.network(item.icon!, width: width, fit: BoxFit.cover),
    );
  }

  _indicator() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.bannerList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () {
              _controller.animateToPage(entry.key);
            },
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Colors.white)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4))),
          );
        }).toList());
  }
}
