import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/utility/path_provider_utility.dart';
import 'package:lili_app/view/login/search_friend.dart';
import 'package:lili_app/view_model/all_request_friends.dart';
import 'package:lili_app/view_model/contact_list.dart';
import 'package:lili_app/view_model/user_data.dart';
import 'package:lili_app/widget/add_friend_widget.dart';

TextEditingController? textEditingController;

class FriendPage extends HookConsumerWidget {
  const FriendPage({super.key, required this.myProfile});
  final UserType myProfile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactListState = ref.watch(contactListNotifierProvider);
    final allRequestFriendsState = ref.watch(allRequestFriendsNotifierProvider);
    final userDataState = ref.watch(userDataNotifierProvider);
    final tabController = useTabController(initialLength: 2);
    final isCancelIcon = useState<bool>(false);
    final isSearch = useState<bool>(false);
    final isRefresAddFriend = useState<bool>(false);
    final isRefresfriendRequest = useState<bool>(false);
    final applyingList = useState<List<String>?>(null);
    final searchResults = useState<List<UserType>?>(null);
    final isContactListStateReady =
        contactListState is AsyncData<ContactListType?>;
    final isAllRequestFriendsReady =
        allRequestFriendsState is AsyncData<List<UserType>?>;
    final ContactListType? contactList = contactListState.value;
    final List<UserType>? allRequestFriends = allRequestFriendsState.value;
    final isDataReady = userDataState is AsyncData<UserType?>;
    final UserType? userData = userDataState.value;

    useEffect(
      () {
        textEditingController ??= TextEditingController();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Future(() async {
            await contactPermission(context);
            if (applyingList.value != null) return;
            final getApplyingList = await localReadList();
            if (!context.mounted) return;
            applyingList.value = getApplyingList;
          });
        });
        if (allRequestFriends == null) {
          final allRequestFriendstNotifier =
              ref.watch(allRequestFriendsNotifierProvider.notifier);
          allRequestFriendstNotifier.getUsers(myProfile.friendRequestList);
        }
        return null;
      },
      [allRequestFriends, applyingList],
    );
    if (!isDataReady || userData == null) {
      return loadinPage(
        context: context,
      );
    }
    return Scaffold(
      extendBody: true,
      backgroundColor: mainBackGroundColor,
      appBar: addFriendAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: xPadding(context),
            child: addFriendTextField(
              context,
              textEditingController,
              isCancelIcon,
              isSearch,
              searchResults,
            ),
          ),
          nTabBar(
            context,
            tabController: tabController,
            titleList: [
              "連絡先の友達",
              "リクエスト(${isAllRequestFriendsReady ? allRequestFriends?.length ?? 0 : myProfile.friendRequestList.length})",
            ],
          ),
          if (!isSearch.value)
            Expanded(
              child: Padding(
                padding: xPadding(context),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    addFriendLists(
                      context,
                      myProfile: userData,
                      contactList: contactList,
                      applyingList: applyingList,
                      isRefresAddFriend: isRefresAddFriend,
                      onRefresh: () => reFetch(ref, applyingList),
                      isDataReady: isContactListStateReady,
                    ),
                    friendRequestLists(
                      context,
                      myProfile: userData,
                      userList: allRequestFriends,
                      applyingList: applyingList,
                      isRefresfriendRequest: isRefresfriendRequest,
                      onRefresh: () => reFetch(ref, applyingList),
                      isDataReady: isAllRequestFriendsReady,
                    ),
                  ],
                ),
              ),
            ),
          if (isSearch.value)
            addFriendSearchList(
              context,
              myProfile: userData,
              searchResults: searchResults,
              applyingList: applyingList,
            ),
        ],
      ),
    );
  }

  Future<void> reFetch(
    WidgetRef ref,
    ValueNotifier<List<String>?> applyingList,
  ) async {
    final profileData = await dbFirestoreReadUser(myProfile.openId);
    if (profileData == null) return;
    final contactListNotifier = ref.read(contactListNotifierProvider.notifier);
    await contactListNotifier.reacquisition();
    final getApplyingList = await localReadList();
    applyingList.value = getApplyingList;
  }
}
