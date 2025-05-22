import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web/screen/api/api_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

final uploadRemoteRepositoryProvider = Provider<UploadRepository>((ref) {
  return UploadRepository();
});

class UploadRepository {
  static final String? apikey = dotenv.env["Apikey"];

  Future<String?> uploadImageToSupabase({
    required Uint8List imageBytes,
    required String fileName,
    required String id,
    required String? token,
  }) async {
    final mimeType = lookupMimeType(fileName) ?? 'application/octet-stream';

    if (token == null || apikey == null) {
      throw Exception("Missing token or API key");
    }

    final url = APIHelper.getURL(
      path: "storage/v1/object/uploads/$id/profile_images/$fileName",
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': mimeType,
        'Authorization': 'Bearer $token',
        'apikey': apikey!,
      },
      body: imageBytes,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final key = responseData["Key"];
      print('✅ Upload success: $key');
      return key;
    } else {
      print('❌ Upload failed: ${response.statusCode} ${response.body}');
      return null;
    }
  }
}
