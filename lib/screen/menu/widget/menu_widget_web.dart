import 'package:flutter/material.dart';
import 'package:flutter_web/screen/login/widgets/loginbody.dart';

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
              Loginbody()
            ],
          ),
        ),
      ),
    );
  }
}
