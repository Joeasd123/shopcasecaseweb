import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web/screen/home/widgetMenu/widget_home_web.dart';
import 'package:flutter_web/screen/menu/view/menu_view.dart';

class HomeWidgetWeb extends StatefulWidget {
  const HomeWidgetWeb({super.key});

  @override
  State<HomeWidgetWeb> createState() => _HomeWidgetWebState();
}

class _HomeWidgetWebState extends State<HomeWidgetWeb> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: 50.h,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            " 02 2177999",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "ทำการทุกวัน เวลา 9.00-21.00 น.",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            label: Text(
                              " @Casecasekub",
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: Icon(Icons.screen_share_outlined,
                                color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          )
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.language_outlined, color: Colors.white),
                      label: Text(
                        "TH",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            MenuView(
              onItemSelected: (index1) {
                setState(() {
                  index = index1;
                });
              },
            ),
            index == 0 ? WidgetHomeWeb() : SizedBox(),
          ],
        ),
      ),
    );
  }
}
