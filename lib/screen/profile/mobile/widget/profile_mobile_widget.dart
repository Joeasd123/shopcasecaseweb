import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web/screen/login/controller/login_controller.dart';
import 'package:flutter_web/screen/profile/controller/profile_controllers.dart';
import 'package:flutter_web/screen/profile/repository/profile_repository.dart';
import 'package:flutter_web/screen/uploadfile/repository/upload_repository.dart';
import 'package:flutter_web/screen/user/controllers/user_controller.dart';
import 'package:flutter_web/screen/user/repository/user_repository.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker_web/image_picker_web.dart';

class ProfilemobileWidget extends StatefulHookConsumerWidget {
  const ProfilemobileWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileWidgetmobileState();
}

class _ProfileWidgetmobileState extends ConsumerState<ProfilemobileWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final String? urlenv = dotenv.env["API__URL"];

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  bool isUploading = false;
  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getUser = ref.watch(getUserProvider);
    final selectImageprofile = ref.watch(uploadFileProfile);
    final imagefile = ref.watch(uploadFileKey);
    final userToken = ref.watch(userTokenProvifer);
    final profilerepository = ref.watch(profileRemoteRepositoryProvider);

    return Scaffold(
        appBar: AppBar(
          title: userToken?['token'] != null ? Text("ข้อมูลโปรไฟล์") : Text(""),
        ),
        body: getUser.when(
          data: (data) {
            if (data.isNotEmpty) {
              controllersProfile["firstname"]?.text =
                  data.first.firstname ?? "";
              controllersProfile["lastname"]?.text = data.first.lastname ?? "";
              controllersProfile["address"]?.text = data.first.address ?? "";
            }
            return Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(children: [
                          selectImageprofile != null
                              ? CircleAvatar(
                                  radius: 60,
                                  backgroundImage:
                                      MemoryImage(selectImageprofile))
                              : data.isNotEmpty &&
                                      data.first.imageprofile != null
                                  ? CircleAvatar(
                                      radius: 60,
                                      backgroundImage: NetworkImage(
                                          data.first.imageprofile.toString()),
                                    )
                                  : CircleAvatar(
                                      radius: 60,
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                      ),
                                    ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt_outlined),
                              onPressed: () async {
                                try {
                                  final mediaData =
                                      await ImagePickerWeb.getImageAsBytes();
                                  if (mediaData != null) {
                                    final imagefilekey = await ref
                                        .read(uploadRemoteRepositoryProvider)
                                        .uploadImageToSupabase(
                                          imageBytes: mediaData,
                                          fileName:
                                              '${DateTime.now().millisecondsSinceEpoch}_profile.png',
                                          id: ref
                                              .read(userTokenProvifer)?['id'],
                                          token: ref.read(
                                              userTokenProvifer)?['token'],
                                        );

                                    ref.read(uploadFileKey.notifier).state =
                                        imagefilekey;
                                    ref.read(uploadFileProfile.notifier).state =
                                        mediaData;

                                    log("✅ อัปโหลดสำเร็จ: $imagefilekey");
                                  } else {
                                    log("❌ ไม่ได้เลือกรูปภาพ");
                                  }
                                } catch (e, stack) {
                                  log("❌ เกิดข้อผิดพลาดระหว่างเลือกรูป: $e");
                                  log("📛 Stack trace: $stack");
                                }
                              },
                            ),
                          ),
                        ]),
                      ),
                      Gap(10),
                      Text("firstname"),
                      Gap(5),
                      TextFormField(
                        controller: controllersProfile["firstname"],
                        validator: (value) => value == null || value.isEmpty
                            ? 'กรุณากรอกข้อมูล'
                            : null,
                        autofocus: false,
                        onTap: () {},
                      ),
                      Gap(10),
                      Text("lastname"),
                      Gap(5),
                      TextFormField(
                        controller: controllersProfile["lastname"],
                        validator: (value) => value == null || value.isEmpty
                            ? 'กรุณากรอกข้อมูล'
                            : null,
                        autofocus: false,
                        onTap: () {},
                      ),
                      Gap(10),
                      Text("address"),
                      Gap(5),
                      TextFormField(
                        controller: controllersProfile["address"],
                        validator: (value) => value == null || value.isEmpty
                            ? 'กรุณากรอกข้อมูล'
                            : null,
                        autofocus: false,
                        onTap: () {},
                      ),
                      Gap(50),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (data.isNotEmpty) {
                              if (isUploading) return;
                              setState(() {
                                isUploading = true;
                              });
                              try {
                                final savedata = await profilerepository.updateUser(
                                    id: userToken?["id"],
                                    token: userToken?["token"],
                                    firstname:
                                        controllersProfile["firstname"]?.text,
                                    lastname:
                                        controllersProfile["lastname"]?.text,
                                    address:
                                        controllersProfile["address"]?.text,
                                    imageprofile: imagefile != null
                                        ? '${urlenv}storage/v1/object/$imagefile'
                                        : data.first.imageprofile.toString());
                                if (savedata != null) {
                                  if (!context.mounted) return;
                                  ref.invalidate(userRemoteRepositoryProvider);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("บันทึกข้อมูลสำเร็จ")),
                                  );
                                }
                              } finally {
                                setState(() {
                                  isUploading = false;
                                });
                              }
                            } else {
                              if (isUploading) return;
                              setState(() {
                                isUploading = true;
                              });
                              try {
                                final savedata = await profilerepository.createUser(
                                    id: userToken?["id"],
                                    token: userToken?["token"],
                                    firstname:
                                        controllersProfile["firstname"]?.text,
                                    lastname:
                                        controllersProfile["lastname"]?.text,
                                    address:
                                        controllersProfile["address"]?.text,
                                    imageprofile: imagefile != null
                                        ? '${urlenv}storage/v1/object/$imagefile'
                                        : data.first.imageprofile.toString());
                                if (savedata != null) {
                                  if (!context.mounted) return;
                                  ref.invalidate(userRemoteRepositoryProvider);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("บันทึกข้อมูลสำเร็จ")),
                                  );
                                }
                              } finally {
                                setState(() {
                                  isUploading = false;
                                });
                              }
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
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => Center(child: const CircularProgressIndicator()),
          error: (err, stack) => const Text("เกิดข้อผิดพลาด"),
        ));
  }
}
