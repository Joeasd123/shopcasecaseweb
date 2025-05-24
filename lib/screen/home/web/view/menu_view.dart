import 'package:flutter/material.dart';
import 'package:flutter_web/screen/home/web/widget/menu_widget_web.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key, this.onItemSelected});
  final Function(int index)? onItemSelected;

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return MenuWidgetWeb(
          onItemSelected: (index) {
            widget.onItemSelected!(index);
          },
        );
      },
    );
  }
}
