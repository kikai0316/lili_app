import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InitialPage extends HookConsumerWidget {
  const InitialPage({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final safeAreaWidth = MediaQuery.of(context).size.width;
    return const Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: SizedBox(),
        ),
      ],
    );
  }
}
