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

  // Future<Map<String, dynamic>> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   if (apikey == null) {
  //     throw Exception('API key is missing');
  //   }

  //   final url = APIHelper.getURL(path: "auth/v1/token?grant_type=password");

  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'apikey': apikey!,
  //     },
  //     body: convert.jsonEncode({
  //       'email': email,
  //       'password': password,
  //     }),
  //   );

  //   debugPrint("Login Response: ${response.body}");

  //   if (response.statusCode == 200) {
  //     return convert.jsonDecode(response.body) as Map<String, dynamic>;
  //   } else {
  //     try {
  //       final errorBody = convert.jsonDecode(response.body);
  //       throw Exception(errorBody['msg']);
  //     } catch (_) {
  //       final errorBody = convert.jsonDecode(response.body);
  //       throw Exception(errorBody['msg']);
  //     }
  //   }
  // }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        // <<< ใช้ Supabase SDK ตรงนี้!
        email: email,
        password: password,
      );

      // เมื่อใช้ signInWithPassword, SDK จะจัดการ Session ให้โดยอัตโนมัติ
      // response.user และ response.session จะมีค่าถ้า Login สำเร็จ
      if (response.user != null && response.session != null) {
        debugPrint("Login Successful via Supabase SDK!");
        debugPrint("User ID: ${response.user!.id}");
        debugPrint("Access Token: ${response.session!.accessToken}");

        // สามารถคืนค่า Map ที่มี id และ token ได้ตามที่คุณเคยทำ
        return {
          'id': response.user!.id,
          'token': response.session!.accessToken,
        };
      } else {
        // กรณีที่ไม่เกิด Exception แต่ user หรือ session เป็น null (ไม่น่าเกิดขึ้นในการใช้งานปกติ)
        throw Exception(
            'Login failed: No user or session in response from SDK.');
      }
    } on AuthException catch (e) {
      // ดักจับ Supabase Auth Exception โดยเฉพาะ
      debugPrint('Auth Error: ${e.message}');
      throw Exception(
          e.message); // โยน exception ด้วยข้อความ error จาก Supabase
    } catch (e) {
      debugPrint('Unexpected Error during login: $e');
      throw Exception('An unexpected error occurred during login.');
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
