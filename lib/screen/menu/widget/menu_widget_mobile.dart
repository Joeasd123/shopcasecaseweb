import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuWidgetMobile extends StatefulWidget {
  const MenuWidgetMobile({super.key, this.onItemSelected});
  final Function(int index)? onItemSelected;

  @override
  State<MenuWidgetMobile> createState() => _MenuWidgetMobileState();
}

class _MenuWidgetMobileState extends State<MenuWidgetMobile> {
  int selectedIndex = 0;
  List<String> datalist = ["หน้าหลัก", "บริการ", "ช่วยเหลือ", "ติดต่อเรา"];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: datalist.asMap().entries.map((entry) {
        int index = entry.key;
        String item = entry.value;
        bool isSelected = selectedIndex == index;

        return Card(
          elevation: 1,
          color: isSelected ? Colors.green : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onItemSelected!(index);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isSelected ? Colors.white : Colors.green,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
