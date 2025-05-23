import 'package:flutter/material.dart';
import 'package:flutter_web/screen/login/controller/login_controller.dart';
import 'package:flutter_web/screen/login/widgets/login_dialog.dart';
import 'package:flutter_web/screen/login/widgets/register_dialog.dart';
import 'package:flutter_web/screen/profile/view/profile_view.dart';
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
    final getUser = ref.watch(getUserProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              if (token != null)
                getUser.when(
                  data: (user) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => ProfileView());
                          },
                          child: getUser.value != null &&
                                  getUser.value!.isNotEmpty &&
                                  getUser.value?.first.imageprofile != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      getUser.value?.first.imageprofile ?? ""),
                                )
                              : CircleAvatar(
                                  child: Icon(
                                    Icons.person,
                                  ),
                                ),
                        ),
                        Gap(10),
                        getUser.value != null &&
                                getUser.value!.isNotEmpty &&
                                getUser.value?.first.imageprofile != null
                            ? Text(
                                '${user.first.firstname ?? ""} ${user.first.lastname ?? ""}',
                                style: const TextStyle(fontSize: 18),
                              )
                            : Text(
                                'New User',
                                style: const TextStyle(fontSize: 18),
                              ),
                        Gap(10),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => const Text("โหลดชื่อผู้ใช้ล้มเหลว"),
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
