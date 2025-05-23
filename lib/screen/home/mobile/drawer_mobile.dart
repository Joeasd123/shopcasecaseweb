import 'package:flutter/material.dart';
import 'package:flutter_web/screen/login/controller/login_controller.dart';
import 'package:flutter_web/screen/login/widgets/login_dialog.dart';
import 'package:flutter_web/screen/login/widgets/register_dialog.dart';
import 'package:flutter_web/screen/user/controllers/user_controller.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DrawerMobile extends ConsumerWidget {
  const DrawerMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userToken = ref.watch(userTokenProvifer);
    final token = userToken?['token'];
    final getUser = ref.watch(getUserProvider);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                if (token != null)
                  Column(
                    children: [
                      if (getUser.value != null &&
                          getUser.value!.isNotEmpty &&
                          getUser.value?.first.imageprofile != null)
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              getUser.value?.first.imageprofile ?? ""),
                        )
                      else
                        CircleAvatar(
                          radius: 40,
                          child: Icon(
                            Icons.person,
                            size: 50,
                          ),
                        ),
                      Gap(10),
                      getUser.value != null &&
                              getUser.value!.isNotEmpty &&
                              getUser.value?.first.imageprofile != null
                          ? Text(
                              '${getUser.value!.first.firstname ?? ""} ${getUser.value!.first.lastname ?? ""}',
                              style: const TextStyle(fontSize: 18),
                            )
                          : Text(
                              'New User',
                              style: const TextStyle(fontSize: 18),
                            ),
                    ],
                  )
                else
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: Icon(
                          Icons.person,
                          size: 50,
                        ),
                      ),
                      Gap(10),
                      TextButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            Future.delayed(Duration(milliseconds: 200), () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return LoginDialog(
                                    onClose: (i) async {
                                      if (i == true) {
                                        Navigator.pop(context, true);
                                        if (!context.mounted) return;
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return RegisterDialog();
                                          },
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            });
                          },
                          child: Text(
                            "เข้าสู่ระบบ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('หน้าหลัก'),
            onTap: () {
              // ทำสิ่งที่ต้องการเมื่อเลือกเมนูนี้ เช่น นำทางไปยังหน้าอื่น
              Navigator.pop(context); // ปิด drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('ตั้งค่า'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          if (token != null)
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('ออกจากระบบ'),
              onTap: () async {
                await ref.read(userTokenProvifer.notifier).clearToken();
                ref.invalidate(userTokenProvifer);
              },
            ),
        ],
      ),
    );
  }
}
