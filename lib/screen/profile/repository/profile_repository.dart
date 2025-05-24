import 'dart:convert' as convert;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web/screen/api/api_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final profileRemoteRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

class ProfileRepository {
  static final String? apikey = dotenv.env["Apikey"];

  Future<String?> createUser({
    required String id,
    String? firstname,
    String? lastname,
    String? address,
    String? imageprofile,
    required String? token,
  }) async {
    if (apikey == null) {
      throw Exception('API key is missing');
    }

    final url = APIHelper.getURL(path: "rest/v1/user_profiles");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'apikey': apikey!,
      },
      body: convert.jsonEncode({
        "id": id,
        'firstname': firstname,
        'lastname': lastname,
        'address': address,
        'imageprofile': imageprofile,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final fullImageUrl = '$imageprofile';

      return fullImageUrl;
    } else {
      try {
        final errorBody = convert.jsonDecode(response.body);
        final message = errorBody['message'] ?? 'Unknown error';
        throw Exception('Update failed: $message');
      } catch (_) {
        throw Exception('Update failed: ${response.body}');
      }
    }
  }

  Future<String?> updateUser({
    required String id,
    String? firstname,
    String? lastname,
    String? address,
    String? imageprofile,
    required String? token,
  }) async {
    if (apikey == null) {
      throw Exception('API key is missing');
    }

    final url = APIHelper.getURL(path: "rest/v1/user_profiles?id=eq.$id");

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'apikey': apikey!,
      },
      body: convert.jsonEncode({
        'firstname': firstname,
        'lastname': lastname,
        'address': address,
        'imageprofile': imageprofile,
      }),
    );

    if (response.statusCode == 204) {
      final fullImageUrl = '$imageprofile';

      return fullImageUrl;
    } else {
      try {
        final errorBody = convert.jsonDecode(response.body);
        final message = errorBody['message'] ?? 'Unknown error';
        throw Exception('Update failed: $message');
      } catch (_) {
        throw Exception('Update failed: ${response.body}');
      }
    }
  }
}
