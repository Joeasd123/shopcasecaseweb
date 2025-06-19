import 'package:flutter/material.dart';
import 'package:flutter_web/screen/login/controller/login_controller.dart';
import 'package:flutter_web/screen/login/service/login_repository.dart';
import 'package:flutter_web/screen/user/controllers/user_controller.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show Supabase, signInWithOAuth, AuthResponse, AuthException;

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
              // ... (โค้ดส่วนบนของคุณ) ...

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
                        final AuthResponse response = await Supabase
                            .instance.client.auth
                            .signInWithPassword(
                          email: email,
                          password: password,
                        );
                        print("Login Response from SDK: ${response.user?.id}");
                        if (response.user != null && response.session != null) {
                          await ref.read(userTokenProvifer.notifier).storeToken(
                                response.session!.accessToken,
                                response.user!.id,
                                response.user!.email ?? '',
                              );
                          ref.invalidate(getUserProvider);
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        } else {
                          throw Exception(
                              'Login failed: No user or session in response from SDK.');
                        }
                      } on AuthException catch (e) {
                        String errorMessage = e.message;
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("เกิดข้อผิดพลาดในการเข้าสู่ระบบ"),
                            content: Text(errorMessage),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("ตกลง"),
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        String errorMessage =
                            "เกิดข้อผิดพลาดที่ไม่คาดคิด: ${e.toString()}";
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
                  child: const Text(
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
