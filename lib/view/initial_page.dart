import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/view/home_page.dart';
import 'package:lili_app/widget/initial_widget.dart';

class InitialPage extends HookConsumerWidget {
  const InitialPage({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: mainBackGroundColor,
          appBar: initialPageAppBar(
            context,
          ),
          body: Stack(
            children: [
              const HomePage(),
              postIconWidget(context),
            ],
          ),
        ),
      ],
    );
  }
}
