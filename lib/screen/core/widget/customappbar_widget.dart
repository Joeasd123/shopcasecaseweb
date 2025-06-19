import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomappbarWidget extends ConsumerWidget implements PreferredSizeWidget {
  const CustomappbarWidget(
      {super.key,
      this.title,
      this.shouldShowBackButton,
      this.actions,
      this.centerTitle = true,
      this.bottom,
      this.fromheight,
      this.fontSize = 22,
      this.backButtonWidget = false,
      this.onClose});
  final String? title;
  final bool? shouldShowBackButton;
  final bool? backButtonWidget;
  final List<Widget>? actions;
  final bool? centerTitle;
  final PreferredSizeWidget? bottom;
  final double? fromheight;
  final double fontSize;
  final Function()? onClose;

  @override
  Size get preferredSize => Size.fromHeight(fromheight ?? 80);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Color(0xffF5F5F5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      toolbarHeight: 150,
      elevation: 0,
      centerTitle: centerTitle,
      leading: shouldShowBackButton == true
          ? IconButton(
              onPressed: () {
                if (backButtonWidget == true) {
                  onClose!();
                } else {
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 25,
              ),
            )
          : null,
      title: Text(
        '$title',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Color(0XFF404040),
        ),
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}
