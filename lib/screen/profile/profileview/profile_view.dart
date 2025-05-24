import 'package:flutter/material.dart';
import 'package:flutter_web/screen/profile/mobile/widget/profile_mobile_widget.dart';
import 'package:flutter_web/screen/profile/web/widget/profile_widgetWeb.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProfileView extends StatefulHookConsumerWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    if (isMobile || isTablet) {
      return ProfilemobileWidget();
    } else if (isDesktop) {
      return ProfileWidgetweb();
    } else {
      return const Center(child: Text('ไม่รองรับแพลตฟอร์มนี้'));
    }
  }
}
