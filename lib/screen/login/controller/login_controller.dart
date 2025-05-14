import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userProvifer = StateProvider<Map<String, dynamic>>((ref) => {});
final userTokenProvifer =
    StateNotifierProvider<TokenNotifier, Map<String, dynamic>?>(
        (ref) => TokenNotifier());

Map<String, TextEditingController> controllersregister = {
  "email": TextEditingController(),
  "password": TextEditingController(),
};

Map<String, TextEditingController> controllersLogin = {
  "email": TextEditingController(),
  "password": TextEditingController(),
};

class TokenNotifier extends StateNotifier<Map<String, dynamic>?> {
  TokenNotifier() : super(null);

  Future<void> storeToken(String? token, String id) async {
    if (token == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('id', id);

    state = {
      'token': token,
      'id': id,
    };
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = prefs.getString('id');

    if (token != null && id != null) {
      state = {
        'token': token,
        'id': id,
      };
    }
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    state = {};
  }
}
