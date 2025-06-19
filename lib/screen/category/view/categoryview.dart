import 'package:flutter/material.dart';
import 'package:flutter_web/screen/category/mobile/widget/category_mobile.dart';
import 'package:flutter_web/screen/category/web/widget/category_web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Categoryview extends ConsumerWidget {
  const Categoryview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final breakpoint = ResponsiveBreakpoints.of(context);

    if (isMobile) {
      return const CategoryMobile();
    } else if (isDesktop || isTablet || breakpoint.breakpoint.name == "IPAD") {
      return const CategoryWeb();
    } else {
      return const Center(child: Text('ไม่รองรับแพลตฟอร์มนี้'));
    }
  }
}
