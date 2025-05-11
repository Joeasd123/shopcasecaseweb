import 'package:flutter/material.dart';
import 'package:flutter_web/screen/home/widget/home_widget_mobile.dart';
import 'package:flutter_web/screen/home/widget/home_widget_web.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth < 600
            ? HomeWidgetMobile()
            : HomeWidgetWeb();
      },
    );
  }
}
