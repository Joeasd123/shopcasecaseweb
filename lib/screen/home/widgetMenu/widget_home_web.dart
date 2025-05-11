import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetHomeWeb extends StatefulWidget {
  const WidgetHomeWeb({super.key});

  @override
  State<WidgetHomeWeb> createState() => _WidgetHomeWebState();
}

class _WidgetHomeWebState extends State<WidgetHomeWeb> {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      carouselController: carouselController,
      options: CarouselOptions(
        height: 600.h,
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
          child: Image.network(
            "assets/images/homeimage.png",
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            },
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Center(
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
