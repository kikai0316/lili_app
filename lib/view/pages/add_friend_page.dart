import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/widget/add_friend_widget.dart';

class AddFriendPage extends HookConsumerWidget {
  const AddFriendPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: mainBackGroundColor,
      appBar: addFriendAppBar(context),
    );
  }
}
