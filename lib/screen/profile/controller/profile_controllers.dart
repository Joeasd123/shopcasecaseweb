import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web/screen/login/controller/login_controller.dart';
import 'package:flutter_web/screen/uploadfile/repository/upload_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

Map<String, TextEditingController> controllersProfile = {
  "firstname": TextEditingController(),
  "lastname": TextEditingController(),
  "address": TextEditingController(),
};
final uploadFileProfile = StateProvider.autoDispose<Uint8List?>((ref) {
  return null;
});

final uploadFileKey = StateProvider.autoDispose<String?>((ref) {
  return null;
});

final uploadFileProfileMobile = StateProvider.autoDispose<XFile?>((ref) {
  return null;
});
Future<dynamic> openDialogImage(
    {BuildContext? context, void Function()? ontap}) async {
  await showModalBottomSheet(
    context: context!,
    builder: (context) => CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: ontap!,
          child: Text(
            "แกลเลอรี่",
            style: TextStyle(
              fontSize: 14.0.sp,
            ),
          ),
        ),
      ],
      cancelButton: TextButton(
        onPressed: () {
          Navigator.pop(context, 'cancel');
        },
        child: Text(
          "cancel",
          style: TextStyle(
            fontSize: 14.0.sp,
          ),
        ),
      ),
    ),
  );
}

Future<void> pickImageWeb(WidgetRef ref) async {
  try {
    final mediaData = await ImagePickerWeb.getImageAsBytes();
    if (mediaData != null) {
      final imagefilekey = await ref
          .read(uploadRemoteRepositoryProvider)
          .uploadImageToSupabase(
            imageBytes: mediaData,
            fileName: '${DateTime.now().millisecondsSinceEpoch}_profile.png',
            id: ref.read(userTokenProvifer)?['id'],
            token: ref.read(userTokenProvifer)?['token'],
          );

      ref.read(uploadFileKey.notifier).state = imagefilekey;
      ref.read(uploadFileProfile.notifier).state = mediaData;

      log("✅ อัปโหลดสำเร็จ: $imagefilekey");
    } else {
      log("❌ ไม่ได้เลือกรูปภาพ");
    }
  } catch (e, stack) {
    log("❌ เกิดข้อผิดพลาดระหว่างเลือกรูป: $e");
    log("📛 Stack trace: $stack");
  }
}
