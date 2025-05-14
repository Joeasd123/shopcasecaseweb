import 'package:flutter_web/screen/user/model/user_model.dart';
import 'package:flutter_web/screen/user/repository/user_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final saveShaerdPreferences = StateProvider.autoDispose<SharedPreferences?>((
  ref,
) {
  return null;
});

final getUserProvider = FutureProvider.family<UserModel, int>((ref, id) async {
  final userRepository = ref.watch(userRemoteRepositoryProvider);
  return await userRepository.getUser(id: id);
});
