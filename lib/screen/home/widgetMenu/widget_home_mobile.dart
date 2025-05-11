import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetHomeMobile extends StatefulWidget {
  const WidgetHomeMobile({super.key});

  @override
  State<WidgetHomeMobile> createState() => _WidgetHomeMobileState();
}

class _WidgetHomeMobileState extends State<WidgetHomeMobile> {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      carouselController: carouselController,
      options: CarouselOptions(
        height: 150.h,
        autoPlay: false,
        aspectRatio: 16 / 9,
        enlargeCenterPage: false,
        viewportFraction: 1,
        enableInfiniteScroll: true,
        onPageChanged: (index, reason) {
          setState(() {
            current = index;
          });
        },
      ),
      itemCount: 1,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return GestureDetector(
            onTap: () {},
            child: Image.asset(
              "assets/images/homeimage.png",
              fit: BoxFit.cover,
            ));
      },
    );
  }
}
