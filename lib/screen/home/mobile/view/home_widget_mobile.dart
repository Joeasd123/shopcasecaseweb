import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web/screen/home/mobile/widget/widget_home_mobile.dart';
import 'package:flutter_web/screen/login/controller/login_controller.dart';
import 'package:flutter_web/screen/profile/profileview/profile_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeWidgetMobile extends StatefulHookConsumerWidget {
  const HomeWidgetMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeWidgetMobileState();
}

class _HomeWidgetMobileState extends ConsumerState<HomeWidgetMobile> {
  final PageStorageBucket bucket = PageStorageBucket();
  Widget homepage = WidgetHomeMobile();
  int selectpage = 0;
  List<Widget> pages = [];
  @override
  void initState() {
    super.initState();
    final userToken = ref.read(userTokenProvifer);

    if (userToken?['token'] != null) {
      pages = [
        WidgetHomeMobile(),
        Center(child: Text('บริการ')),
        ProfileView(),
      ];
    } else {
      pages = [
        WidgetHomeMobile(),
        Center(child: Text('บริการ')),
      ];
    }

    homepage = pages[0];
  }

  void onItem(int index) {
    setState(() {
      selectpage = index;
      homepage = pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final userToken = ref.watch(userTokenProvifer);

    final pages = [
      WidgetHomeMobile(),
      Center(child: Text('บริการ')),
      if (userToken?['token'] != null) ProfileView(),
    ];

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: PageStorage(
          bucket: bucket,
          child: pages[selectpage],
        ),
        bottomNavigationBar: Card(
          elevation: 10,
          child: BottomNavigationBar(
              onTap: onItem,
              currentIndex: selectpage,
              // selectedItemColor: kPrimaryColor,
              unselectedLabelStyle: TextStyle(color: Colors.grey),
              unselectedFontSize: 16,
              selectedFontSize: 16,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.grey,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'หน้าแรก'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.miscellaneous_services), label: 'บริการ'),
                if (userToken?['token'] != null)
                  BottomNavigationBarItem(
                      icon: Icon(Icons.account_box_outlined), label: 'โปรไฟล์'),
              ]),
        ),
      ),
    );
  }
}
