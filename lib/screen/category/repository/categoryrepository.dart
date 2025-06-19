import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web/screen/api/api_helper.dart';
import 'package:flutter_web/screen/category/model/category_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final categoryRemoteRepositoryProvider = Provider<Categoryrepository>((ref) {
  return Categoryrepository();
});

class Categoryrepository {
  static final String? apikey = dotenv.env["Apikey"];

  Future<List<CategoryModel>> getgategory() async {
    final url = APIHelper.getURL(path: "rest/v1/categories");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'apikey': apikey!,
        },
      );

      debugPrint("RESPONSEBanners: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = convert.jsonDecode(response.body);

        final List<CategoryModel> category = data.map<CategoryModel>((e) {
          return CategoryModel.fromJson(e);
        }).toList();
        return category;
      } else {
        throw Exception('Error: ${response.body}');
      }
    } catch (e) {
      debugPrint("ERROR in getUser: $e");
      rethrow;
    }
  }
}
