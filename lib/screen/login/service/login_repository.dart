import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web/screen/api/api_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

final authRemoteRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository();
});

class LoginRepository {
  final supabase = Supabase.instance.client;
  static final String? apikey = dotenv.env["Apikey"];

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    if (apikey == null) {
      throw Exception('API key is missing');
    }

    final url = APIHelper.getURL(path: "auth/v1/token?grant_type=password");
    debugPrint("API Key: $apikey");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'apikey': apikey!,
      },
      body: convert.jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    debugPrint("Login Response: ${response.body}");

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      try {
        final errorBody = convert.jsonDecode(response.body);
        throw Exception(errorBody['msg']);
      } catch (_) {
        final errorBody = convert.jsonDecode(response.body);
        throw Exception(errorBody['msg']);
      }
    }
  }

  Future<String?> register({
    required String email,
    required String password,
  }) async {
    if (apikey == null) {
      throw Exception('API key is missing');
    }

    final url = APIHelper.getURL(path: "auth/v1/signup");
    debugPrint("API Key: $apikey");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'apikey': apikey!,
      },
      body: convert.jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    debugPrint("Register Response: ${response.body}");

    if (response.statusCode == 200) {
      final dataresponse = convert.jsonDecode(response.body);
      final data = dataresponse["id"];
      return data;
    } else {
      try {
        final errorBody = convert.jsonDecode(response.body);
        final message = errorBody['message'] ?? 'Unknown error';
        throw Exception('Login failed: $message');
      } catch (_) {
        throw Exception('Login failed: ${response.body}');
      }
    }
  }
}
