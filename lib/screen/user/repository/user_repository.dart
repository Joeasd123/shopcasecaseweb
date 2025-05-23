import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web/screen/api/api_helper.dart';
import 'package:flutter_web/screen/user/model/user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final userRemoteRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class UserRepository {
  static final String? apikey = dotenv.env["Apikey"];
  Future<List<UserModel>> getUser({
    required String? id,
    required String? token,
  }) async {
    final url = APIHelper.getURL(path: "rest/v1/user_profiles?id=eq.$id");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'apikey': apikey!,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = convert.jsonDecode(response.body);

        final List<UserModel> searchDoc = data.map<UserModel>((e) {
          return UserModel.fromJson(e);
        }).toList();
        return searchDoc;
      } else {
        throw Exception('Error: ${response.body}');
      }
    } catch (e) {
      debugPrint("ERROR in getUser: $e");
      rethrow;
    }
  }
}
