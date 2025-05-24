import 'package:flutter/material.dart';
import 'package:flutter_web/screen/home/mobile/view/home_widget_mobile.dart';
import 'package:flutter_web/screen/home/web/view/home_widget_web.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final breakpoint = ResponsiveBreakpoints.of(context);
    debugPrint("หน้าจอ${breakpoint.breakpoint.name.toString()}");

    if (isMobile) {
      return const HomeWidgetMobile();
    } else if (isDesktop || isTablet || breakpoint.breakpoint.name == "IPAD") {
      return const HomeWidgetWeb();
    } else {
      return const Center(child: Text('ไม่รองรับแพลตฟอร์มนี้'));
    }
  }
}
