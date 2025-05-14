import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserProfileWeb extends StatefulHookConsumerWidget {
  const UserProfileWeb({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfileWebState();
}

class _UserProfileWebState extends ConsumerState<UserProfileWeb> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [],
      ),
    );
  }
}
