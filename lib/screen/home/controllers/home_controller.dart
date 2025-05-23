import 'package:flutter_web/screen/home/model/banners_model.dart';
import 'package:flutter_web/screen/home/repository/home_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final indexdefault = StateProvider.autoDispose<int?>((
  ref,
) {
  return 0;
});

final getbannersProvider = FutureProvider<List<BannersModel>>((
  ref,
) async {
  final userRepository = ref.watch(homeRemoteRepositoryProvider);
  return await userRepository.getBanners();
});
