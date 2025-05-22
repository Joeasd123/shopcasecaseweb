import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web/screen/login/controller/login_controller.dart';
import 'package:flutter_web/screen/profile/controller/profile_controllers.dart';
import 'package:flutter_web/screen/profile/repository/profile_repository.dart';
import 'package:flutter_web/screen/user/controllers/user_controller.dart';
import 'package:flutter_web/screen/user/repository/user_repository.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileWidget extends StatefulHookConsumerWidget {
  const ProfileWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends ConsumerState<ProfileWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final String? urlenv = dotenv.env["API__URL"];
  @override
  Widget build(BuildContext context) {
    final getUser = ref.watch(getUserProvider);
    final selectImageprofile = ref.watch(uploadFileProfile);
    final imagefile = ref.watch(uploadFileKey);
    final userToken = ref.watch(userTokenProvifer);
    final profilerepository = ref.watch(profileRemoteRepositoryProvider);

    return getUser.when(
      data: (data) {
        if (data.isNotEmpty) {
          controllersProfile["firstname"]?.text = data.first.firstname ?? "";
          controllersProfile["lastname"]?.text = data.first.lastname ?? "";
          controllersProfile["address"]?.text = data.first.address ?? "";
        }
        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(children: [
                      selectImageprofile != null
                          ? CircleAvatar(
                              radius: 70.h,
                              backgroundImage: kIsWeb
                                  ? MemoryImage(selectImageprofile.bytes!)
                                  : FileImage(
                                          File(selectImageprofile.path ?? ''))
                                      as ImageProvider,
                            )
                          : CircleAvatar(
                              radius: 70.h,
                              backgroundImage: NetworkImage(
                                  data.first.imageprofile.toString()),
                            ),
                      GestureDetector(
                        onTap: () async {
                          if (kIsWeb) {
                            await pickImageWeb(ref);
                          } else {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              ref.read(uploadFileProfileMobile.notifier).state =
                                  pickedFile;
                            }
                          }
                        },
                        child: Icon(Icons.camera_alt_outlined),
                      )
                    ]),
                  ),
                  Gap(10.h),
                  Text("firstname"),
                  Gap(5.h),
                  TextFormField(
                    controller: controllersProfile["firstname"],
                    validator: (value) => value == null || value.isEmpty
                        ? 'กรุณากรอกข้อมูล'
                        : null,
                    autofocus: false,
                    onTap: () {},
                  ),
                  Gap(10.h),
                  Text("lastname"),
                  Gap(5.h),
                  TextFormField(
                    controller: controllersProfile["lastname"],
                    validator: (value) => value == null || value.isEmpty
                        ? 'กรุณากรอกข้อมูล'
                        : null,
                    autofocus: false, // ปิด autofocus
                    onTap: () {},
                  ),
                  Gap(10.h),
                  Text("address"),
                  Gap(5.h),
                  TextFormField(
                    controller: controllersProfile["address"],
                    validator: (value) => value == null || value.isEmpty
                        ? 'กรุณากรอกข้อมูล'
                        : null,
                    autofocus: false, // ปิด autofocus
                    onTap: () {},
                  ),
                  Gap(50.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final savedata = await profilerepository.updateUser(
                            id: userToken?["id"],
                            token: userToken?["token"],
                            firstname: controllersProfile["firstname"]?.text,
                            lastname: controllersProfile["lastname"]?.text,
                            address: controllersProfile["address"]?.text,
                            imageprofile: imagefile != null
                                ? '${urlenv}storage/v1/object/$imagefile'
                                : data.first.imageprofile.toString());

                        if (savedata != null) {
                          if (!context.mounted) return;
                          ref.invalidate(userRemoteRepositoryProvider);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        "บันทึก",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Gap(10.h),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("ยกเลิก")),
                  )
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => const Text("เกิดข้อผิดพลาด"),
    );
  }
}
