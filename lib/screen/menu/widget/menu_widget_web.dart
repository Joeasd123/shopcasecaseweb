import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MenuWidgetWeb extends StatefulWidget {
  const MenuWidgetWeb({super.key, this.onItemSelected});
  final Function(int index)? onItemSelected;

  @override
  State<MenuWidgetWeb> createState() => _MenuWidgetWebState();
}

class _MenuWidgetWebState extends State<MenuWidgetWeb> {
  int selectedIndex = 0;
  List<String> datalist = ["หน้าหลัก", "บริการ", "ช่วยเหลือ", "ติดต่อเรา"];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: datalist.asMap().entries.map((entry) {
                  int index = entry.key;
                  String item = entry.value;
                  bool isSelected = selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        widget.onItemSelected!(index);
                      },
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 18,
                          color: isSelected ? Colors.green : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  Text(
                    "Suthep",
                    style: TextStyle(fontSize: 18),
                  ),
                  Gap(10.w),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("เข้าสู่ระบบ"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Username"),
                                  Gap(5.h),
                                  TextFormField(),
                                  Gap(5.h),
                                  Text("Password"),
                                  Gap(5.h),
                                  TextFormField(),
                                  Gap(20.h),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: Text(
                                        "ตกลง",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    label: Text(
                      "เข้าสู่ระบบ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    icon:
                        Icon(Icons.screen_share_outlined, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
