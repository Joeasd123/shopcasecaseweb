import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/screen/profile/widget/profile_widgetMobile.dart';
import 'package:flutter_web/screen/profile/widget/profile_widgetWeb.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileView extends StatefulHookConsumerWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return ProfileWidgetweb();
    } else if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return ProfileWidgetmobile();
    } else {
      return Center(child: Text('ไม่รองรับแพลตฟอร์มนี้'));
    }
  }
}
