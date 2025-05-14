import 'dart:convert' as convert;

import 'package:flutter_web/screen/api/api_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final authRemoteRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository();
});

class LoginRepository {
  Future<Map<String, dynamic>> login({
    required String? email,
    required String? password,
  }) async {
    final url = APIHelper.getURL(path: "login");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({
        'email': email ?? "",
        'password': password ?? "",
      }),
    );

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error: ${response.body}');
    }
  }
}
