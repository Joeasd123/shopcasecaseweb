import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web/screen/home/mobile/widget_home_mobile.dart';

class HomeWidgetMobile extends StatefulWidget {
  const HomeWidgetMobile({super.key});

  @override
  State<HomeWidgetMobile> createState() => _HomeWidgetMobileState();
}

class _HomeWidgetMobileState extends State<HomeWidgetMobile> {
  final PageStorageBucket bucket = PageStorageBucket();
  Widget homepage = WidgetHomeMobile();
  int selectpage = 0;
  void onItem(int index) {
    setState(() {
      selectpage = index;
      if (selectpage == 0) {
        WidgetHomeMobile();
      } else if (selectpage == 1) {
      } else if (selectpage == 2) {
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: PageStorage(
          bucket: bucket,
          child: homepage,
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
                selectpage == 0
                    ? BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'หน้าแรก')
                    : BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'หน้าแรก'),
                selectpage == 1
                    ? BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'บริการ')
                    : BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'บริการ'),
                selectpage == 2
                    ? BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'โปรไฟล์')
                    : BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'โปรไฟล์'),
              ]),
        ),
      ),
    );
  }
}
