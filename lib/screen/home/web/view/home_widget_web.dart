import 'package:flutter/material.dart';
import 'package:flutter_web/screen/home/web/view/menu_view.dart';
import 'package:flutter_web/screen/home/web/widget/widget_home_web.dart';

class HomeWidgetWeb extends StatefulWidget {
  const HomeWidgetWeb({super.key});

  @override
  State<HomeWidgetWeb> createState() => _HomeWidgetWebState();
}

class _HomeWidgetWebState extends State<HomeWidgetWeb> {
  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            " 02 2177999",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "ทำการทุกวัน เวลา 9.00-21.00 น.",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
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
