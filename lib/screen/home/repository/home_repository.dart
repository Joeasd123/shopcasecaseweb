import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web/screen/api/api_helper.dart';
import 'package:flutter_web/screen/home/model/banners_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final homeRemoteRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository();
});

class HomeRepository {
  static final String? apikey = dotenv.env["Apikey"];

  Future<List<BannersModel>> getBanners() async {
    final url = APIHelper.getURL(path: "rest/v1/banners");

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

        final List<BannersModel> banners = data.map<BannersModel>((e) {
          return BannersModel.fromJson(e);
        }).toList();
        return banners;
      } else {
        throw Exception('Error: ${response.body}');
      }
    } catch (e) {
      debugPrint("ERROR in getUser: $e");
      rethrow;
    }
  }
}
