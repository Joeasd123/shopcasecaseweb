import 'package:flutter/material.dart';
import 'package:flutter_web/screen/login/controller/login_controller.dart';
import 'package:flutter_web/screen/login/service/login_repository.dart';
import 'package:flutter_web/screen/user/controllers/user_controller.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginDialog extends StatefulHookConsumerWidget {
  const LoginDialog({super.key, this.onClose});
  final Function(bool)? onClose;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginDialogState();
}

class _LoginDialogState extends ConsumerState<LoginDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRemoteRepositoryProvider);

    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Gap(15),
              Text("email"),
              Gap(5),
              TextFormField(
                focusNode: emailFocusNode,
                controller: controllersLogin["email"],
                validator: (value) =>
                    value == null || value.isEmpty ? 'กรุณากรอกอีเมล' : null,
                autofocus: false, // ปิด autofocus
                onTap: () {
                  emailFocusNode.requestFocus();
                },
              ),
              Gap(10),
              Text("Password"),
              Gap(5),
              TextFormField(
                focusNode: passwordFocusNode,
                controller: controllersLogin["password"],
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'กรุณากรอกรหัสผ่าน' : null,
                autofocus: false,
                onTap: () {
                  passwordFocusNode.requestFocus();
                },
              ),
              Gap(20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final email = controllersLogin["email"]?.text ?? '';
                      final password = controllersLogin["password"]?.text ?? '';
                      print(
                          "พยายามเข้าสู่ระบบด้วย email: $email, password: $password");

                      try {
                        final data = await authRepository.login(
                          email: email,
                          password: password,
                        );
                        print("ผลลัพธ์จาก API: $data");

                        await ref.read(userTokenProvifer.notifier).storeToken(
                              data["access_token"],
                              data["user"]["id"].toString(),
                              data["user"]["email"].toString(),
                            );

                        ref.invalidate(getUserProvider);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      } catch (e) {
                        String errorMessage = "เข้าสู่ระบบล้มเหลว";
                        if (e is Exception) {
                          errorMessage =
                              e.toString().replaceFirst('Exception: ', '');
                        }

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("เกิดข้อผิดพลาด"),
                            content: Text(errorMessage),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("ตกลง"),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    "ตกลง",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Gap(5),
              Center(
                child: TextButton(
                  onPressed: () {
                    widget.onClose?.call(true);
                  },
                  child: Text("สมัครสมาชิก"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
