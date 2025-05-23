import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_web/screen/login/controller/login_controller.dart';
import 'package:flutter_web/screen/login/service/login_repository.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterDialog extends StatefulHookConsumerWidget {
  const RegisterDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends ConsumerState<RegisterDialog> {
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
                  "สมัครสมาชิก",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Gap(15),
              Text("Username"),
              Gap(5),
              TextFormField(
                focusNode: emailFocusNode,
                controller: controllersregister["email"],
                validator: (value) =>
                    value == null || value.isEmpty ? 'กรุณากรอกอีเมล' : null,
                autofocus: false,
                onTap: () {
                  emailFocusNode.requestFocus();
                },
              ),
              Gap(10),
              Text("Password"),
              Gap(5),
              TextFormField(
                focusNode: passwordFocusNode,
                controller: controllersregister["password"],
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
                      final data = await authRepository.login(
                        email: controllersLogin["email"]?.text ?? '',
                        password: controllersLogin["password"]?.text ?? '',
                      );
                      log(data.toString());
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
              Gap(20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: Text("ยกเลิก"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
