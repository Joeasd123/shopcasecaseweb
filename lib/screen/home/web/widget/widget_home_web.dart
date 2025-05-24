import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/screen/home/controllers/home_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WidgetHomeWeb extends StatefulHookConsumerWidget {
  const WidgetHomeWeb({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WidgetHomeWebState();
}

class _WidgetHomeWebState extends ConsumerState<WidgetHomeWeb> {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  int current = 0;
  @override
  Widget build(BuildContext context) {
    final bannersdata = ref.watch(getbannersProvider);

    return bannersdata.when(
      data: (data) {
        return CarouselSlider.builder(
          carouselController: carouselController,
          options: CarouselOptions(
            height: 600,
            autoPlay: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            enlargeCenterPage: false,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                current = index;
              });
            },
          ),
          itemCount: data.first.bannersurl?.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return GestureDetector(
              onTap: () {},
              child: Image.network(
                data.first.bannersurl![index],
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
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => const Text("โหลดข้อมูลล้มเหลว"),
    );
  }
}
