import 'package:hooks_riverpod/hooks_riverpod.dart';

final indexdefault = StateProvider.autoDispose<int?>((
  ref,
) {
  return 0;
});
