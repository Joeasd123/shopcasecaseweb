import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/screen/home/widget/home_widget_mobile.dart';
import 'package:flutter_web/screen/home/widget/home_widget_web.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return HomeWidgetWeb();
    } else if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return HomeWidgetMobile();
    } else {
      return Center(child: Text('ไม่รองรับแพลตฟอร์มนี้'));
    }
  }
}
