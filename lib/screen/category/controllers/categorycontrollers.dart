import 'package:flutter_web/screen/category/model/category_model.dart';
import 'package:flutter_web/screen/category/repository/categoryrepository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final fetchcategoryMobilepovider =
    FutureProvider<List<CategoryModel>>((ref) async {
  final categorypovider = ref.watch(categoryRemoteRepositoryProvider);
  return await categorypovider.getgategory();
});
