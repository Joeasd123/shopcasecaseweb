import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/screen/category/view/categoryview.dart';
import 'package:flutter_web/screen/home/controllers/home_controller.dart';
import 'package:flutter_web/screen/home/mobile/widget/drawer_mobile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WidgetHomeMobile extends StatefulHookConsumerWidget {
  const WidgetHomeMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WidgetHomeMobileState();
}

class _WidgetHomeMobileState extends ConsumerState<WidgetHomeMobile> {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  int current = 0;
  @override
  Widget build(BuildContext context) {
    final bannersdata = ref.watch(getbannersProvider);

    return Scaffold(
      drawer: DrawerMobile(),
      appBar: AppBar(),
      body: Column(
        children: [
          bannersdata.when(
            data: (data) {
              return CarouselSlider.builder(
                carouselController: carouselController,
                options: CarouselOptions(
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
            loading: () => Center(child: const CircularProgressIndicator()),
            error: (err, stack) => const Text("โหลดข้อมูลล้มเหลว"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("หมวดหมู่"),
                  ],
                ),
                Categoryview()
              ],
            ),
          )
        ],
      ),
    );
  }
}
