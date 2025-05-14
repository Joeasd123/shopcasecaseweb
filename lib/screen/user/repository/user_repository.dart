import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_web/screen/api/api_helper.dart';
import 'package:flutter_web/screen/user/model/user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final userRemoteRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class UserRepository {
  Future<UserModel> getUser({
    required int? id,
  }) async {
    final url = APIHelper.getURL(path: "user/${id.toString()}");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${userToken?['token']}',
        },
      );

      debugPrint("RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Error: ${response.body}');
      }
    } catch (e) {
      debugPrint("ERROR in getUser: $e");
      rethrow;
    }
  }
}
