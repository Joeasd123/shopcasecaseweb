import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web/screen/login/controller/login_controller.dart';
import 'package:flutter_web/screen/uploadfile/repository/upload_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

Map<String, TextEditingController> controllersProfile = {
  "firstname": TextEditingController(),
  "lastname": TextEditingController(),
  "address": TextEditingController(),
};
final uploadFileProfile = StateProvider.autoDispose<PlatformFile?>((ref) {
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
  final uploadrepository = ref.watch(uploadRemoteRepositoryProvider);
  final userToken = ref.watch(userTokenProvifer);
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    withData: true,
  );

  if (result != null && result.files.single.bytes != null) {
    final Uint8List imageBytes = result.files.single.bytes!;
    final fileName = result.files.single.name;
    final safeFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
    final imagefilekey = await uploadrepository.uploadImageToSupabase(
        imageBytes: imageBytes,
        fileName: safeFileName,
        id: userToken?['id'],
        token: userToken?['token']);
    ref.read(uploadFileKey.notifier).state = imagefilekey;
    ref.read(uploadFileProfile.notifier).state = result.files.single;
  }
}
