import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web/screen/login/controller/login_controller.dart';
import 'package:flutter_web/screen/login/widgets/login_dialog.dart';
import 'package:flutter_web/screen/login/widgets/register_dialog.dart';
import 'package:flutter_web/screen/user/controllers/user_controller.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Loginbody extends StatefulHookConsumerWidget {
  const Loginbody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginbodyState();
}

class _LoginbodyState extends ConsumerState<Loginbody> {
  @override
  Widget build(BuildContext context) {
    final userToken = ref.watch(userTokenProvifer);
    final token = userToken?['token'];
    final id = userToken?['id'];
    final getUser = (id != null)
        ? ref.watch(getUserProvider(int.parse(id)))
        : const AsyncValue.loading();

    print("ผลลัพธ์จาก ID: $id");
    print("ผลลัพธ์จาก Token: $token");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              if (token != null)
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/images/user.png"),
                    ),
                    Gap(10.w),
                    getUser.when(
                      data: (user) => Text(
                        user.name ?? "",
                        style: const TextStyle(fontSize: 18),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (err, stack) =>
                          const Text("โหลดชื่อผู้ใช้ล้มเหลว"),
                    ),
                    Gap(10.w),
                  ],
                ),
              if (userToken == null)
                ElevatedButton.icon(
                  onPressed: () async {
                    await showDialog(
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
                                    });
                              }
                            },
                          );
                        });
                  },
                  label: Text(
                    "เข้าสู่ระบบ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  icon: Icon(Icons.screen_share_outlined, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: () async {
                    await ref.read(userTokenProvifer.notifier).clearToken();
                    ref.invalidate(userTokenProvifer);
                    setState(() {});
                  },
                  label: Text(
                    "ออกจากระบบ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  icon: Icon(Icons.screen_share_outlined, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
