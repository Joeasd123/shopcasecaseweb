import 'package:flutter/material.dart';
import 'package:flutter_web/screen/home/widgetMenu/widget_home_mobile.dart';
import 'package:flutter_web/screen/menu/view/menu_view.dart';

class HomeWidgetMobile extends StatefulWidget {
  const HomeWidgetMobile({super.key});

  @override
  State<HomeWidgetMobile> createState() => _HomeWidgetMobileState();
}

class _HomeWidgetMobileState extends State<HomeWidgetMobile> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              MenuView(
                onItemSelected: (index1) {
                  setState(() {
                    index = index1;
                  });
                },
              ),
              index == 0 ? WidgetHomeMobile() : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
