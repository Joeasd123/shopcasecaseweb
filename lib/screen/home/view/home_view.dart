import 'package:flutter/material.dart';
import 'package:flutter_web/screen/home/widget/home_widget_mobile.dart';
import 'package:flutter_web/screen/home/widget/home_widget_web.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    if (isMobile || isTablet) {
      return const HomeWidgetMobile();
    } else if (isDesktop) {
      return const HomeWidgetWeb();
    } else {
      return const Center(child: Text('ไม่รองรับแพลตฟอร์มนี้'));
    }
  }
}
