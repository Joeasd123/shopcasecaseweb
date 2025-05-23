import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

Map<String, TextEditingController> controllersProfile = {
  "firstname": TextEditingController(),
  "lastname": TextEditingController(),
  "address": TextEditingController(),
};
final uploadFileProfile = StateProvider.autoDispose<Uint8List?>((ref) {
  return null;
});

final uploadFile = StateProvider.autoDispose<PlatformFile?>((ref) {
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
              fontSize: 14.0,
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
            fontSize: 14.0,
          ),
        ),
      ),
    ),
  );
}

// Future<void> pickImageWeb(WidgetRef ref) async {
//   log("✅ pickImageWeb ถูกเรียกแล้ว");
//   final uploadrepository = ref.watch(uploadRemoteRepositoryProvider);
//   final userToken = ref.watch(userTokenProvifer);
//   try {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       withData: true,
//     );
//     log("📂 result: ${result?.files.single.name}");
//     if (result != null && result.files.single.bytes != null) {
//       final Uint8List imageBytes = result.files.single.bytes!;
//       final fileName = result.files.single.name;
//       final safeFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
//       final imagefilekey = await uploadrepository.uploadImageToSupabase(
//           imageBytes: imageBytes,
//           fileName: safeFileName,
//           id: userToken?['id'],
//           token: userToken?['token']);
//       ref.read(uploadFileKey.notifier).state = imagefilekey;
//       ref.read(uploadFile.notifier).state = result.files.single;
//       log("✅ อัปโหลดสำเร็จ: $imagefilekey");
//     } else {
//       log("❌ ไม่ได้เลือกไฟล์ หรือเลือกไฟล์ไม่สำเร็จ");
//     }
//   } catch (e, stack) {
//     log("❌ เกิดข้อผิดพลาดระหว่างเลือกไฟล์: $e");
//     log("📛 Stack trace: $stack");
//   }
// }
