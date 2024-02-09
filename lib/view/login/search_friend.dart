import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/message.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/notistack_utility.dart';
import 'package:lili_app/utility/permission_utlity.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/view/home_page.dart';
import 'package:lili_app/view_model/contact_list.dart';
import 'package:lili_app/view_model/user_data.dart';
import 'package:lili_app/widget/add_friend_widget.dart';
import 'package:permission_handler/permission_handler.dart';

TextEditingController? textEditingController;

class SearchFriendPage extends HookConsumerWidget {
  const SearchFriendPage({super.key, required this.myProfile});
  final UserType myProfile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactListState = ref.watch(contactListNotifierProvider);
    final isCancelIcon = useState<bool>(false);
    final isSearch = useState<bool>(false);
    final isRefresAddFriend = useState<bool>(false);
    final searchResults = useState<List<UserType>?>(null);
    final isDataReady = contactListState is AsyncData<ContactListType?>;
    final ContactListType? contactList = contactListState.value;
    return Scaffold(
      extendBody: true,
      backgroundColor: mainBackGroundColor,
      appBar: nAppBar(
        context,
        title: "友達を探す",
      ),
      body: Padding(
        padding: xPadding(context),
        child: Column(
          children: [
            addFriendTextField(
              context,
              textEditingController,
              isCancelIcon,
              isSearch,
              searchResults,
            ),
            Expanded(
              child: isSearch.value
                  ? addFriendSearchList(
                      context,
                      myProfile: myProfile,
                      searchResults: searchResults,
                    )
                  : addFriendLists(
                      context,
                      myProfile: myProfile,
                      isRefresAddFriend: isRefresAddFriend,
                      contactList: contactList,
                      isDataReady: isDataReady,
                      onRefresh: () => reFetch(
                        ref,
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: xPadding(context),
          child: mainButton(
            context,
            text: "次へ",
            onTap: () => ScreenTransition(context, const HomePage()).normal(),
          ),
        ),
      ),
    );
  }

  Future<void> reFetch(
    WidgetRef ref,
  ) async {
    final contactListNotifier = ref.read(contactListNotifierProvider.notifier);
    final userDataNotifier = ref.read(userDataNotifierProvider.notifier);
    await contactListNotifier.reacquisition();
    await userDataNotifier.reacquisition();
  }
}

Future<void> contactPermission(BuildContext context) async {
  final isPermission = await checkContactsPermission();
  if (!context.mounted) return;
  if (!isPermission) {
    showAlertDialog(
      context,
      title: "連絡先にアクセスできません。",
      subTitle: eMessageNotContactsPermission,
      rightButtonText: !isPermission ? "設定画面へ" : null,
      leftButtonText: "後で",
      rightButtonOnTap: () => openAppSettings(),
    );
  }
}
