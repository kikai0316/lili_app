import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/img.dart';
import 'package:lili_app/constant/message.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/utility/notistack_utility.dart';
import 'package:lili_app/utility/path_provider_utility.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/view/pages/fullscreen_friend_page.dart';
import 'package:lili_app/view_model/all_request_friends.dart';

class OnAddFriend extends HookConsumerWidget {
  const OnAddFriend({
    super.key,
    required this.onContactListType,
    required this.applyingList,
    required this.myProfile,
  });
  final OnContactListType onContactListType;
  final ValueNotifier<List<String>?> applyingList;
  final UserType myProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isLoading = useState<bool>(false);
    final userData = onContactListType.userData;
    final contactsName = onContactListType.contactsName;
    final friendsStateType = addFriendsStateType(userData);
    final List<String> dataList = userData != null
        ? [
            userData.name,
            userData.userId,
            if (contactsName != null) contactsName,
          ]
        : [
            if (contactsName != null) contactsName,
            onContactListType.phoneNumber,
          ];

    return Padding(
      padding: customPadding(bottom: safeAreaHeight * 0.02),
      child: Container(
        height: safeAreaWidth * 0.17,
        width: safeAreaWidth,
        color: mainBackGroundColor,
        child: Stack(
          children: [
            CustomAnimatedOpacityButton(
              opacity: 0.4,
              onTap: userData != null
                  ? () => ScreenTransition(
                        context,
                        FullScreenFriendPage(
                          userData: userData,
                          myProfile: myProfile,
                          friendsStateType: friendsStateType,
                        ),
                      ).top()
                  : null,
              child: ColoredBox(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Padding(
                      padding: customPadding(right: safeAreaWidth * 0.03),
                      child: imgWidget(
                        size: safeAreaWidth * 0.17,
                        isCircle: true,
                        assetFile: notImg(),
                        networkUrl: userData?.img,
                        memoryData: onContactListType.contactsImg,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < dataList.length; i++)
                            Row(
                              children: [
                                if (i == 2)
                                  Padding(
                                    padding: customPadding(
                                      right: safeAreaWidth * 0.01,
                                    ),
                                    child: Icon(
                                      Icons.account_circle,
                                      color: Colors.grey,
                                      size: safeAreaWidth / 28,
                                    ),
                                  ),
                                Expanded(
                                  child: Padding(
                                    padding: yPadding(
                                      context,
                                      ySize: safeAreaHeight * 0.004,
                                    ),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: nText(
                                        dataList[i],
                                        color:
                                            i == 0 ? Colors.white : Colors.grey,
                                        fontSize:
                                            safeAreaWidth / (i == 0 ? 28 : 35),
                                        bold: 700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: safeAreaWidth * 0.18,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: !isLoading.value
                  ? mainButton(
                      context,
                      width: safeAreaWidth * 0.15,
                      height: safeAreaHeight * 0.04,
                      radius: 50,
                      backGroundColor:
                          mainButtonBackGroundColor(friendsStateType),
                      textColor: mainButtonTextColor(friendsStateType),
                      fontSize: safeAreaWidth / 30,
                      text: mainButtonText(friendsStateType),
                      onTap: mainButtonTapEvent(
                        context,
                        ref,
                        friendsStateType,
                        isLoading,
                        onContactListType,
                        applyingList,
                        myProfile,
                      ),
                    )
                  : Padding(
                      padding: xPadding(context),
                      child: nIndicatorWidget(
                        safeAreaWidth / 30,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  FriendsStateType addFriendsStateType(UserType? userType) {
    if (userType == null) return FriendsStateType.notAppUser;
    if (myProfile.friendList.contains(userType.openId)) {
      return FriendsStateType.appUserFriended;
    }
    if (myProfile.friendRequestList.contains(userType.openId)) {
      return FriendsStateType.appUserReceivedApplication;
    }
    if ((applyingList.value ?? []).contains(userType.openId)) {
      return FriendsStateType.appUserApplication;
    }
    return FriendsStateType.appUserNoRelationship;
  }
}

Color mainButtonBackGroundColor(FriendsStateType addFriendsStateType) {
  switch (addFriendsStateType) {
    case FriendsStateType.notAppUser:
      return subColor;
    case FriendsStateType.appUserNoRelationship:
      return Colors.white;
    case FriendsStateType.appUserReceivedApplication:
      return Colors.blue;
    default:
      return Colors.transparent;
  }
}

Color mainButtonTextColor(FriendsStateType addFriendsStateType) {
  switch (addFriendsStateType) {
    case FriendsStateType.appUserNoRelationship:
      return Colors.black;
    case FriendsStateType.appUserApplication:
      return Colors.grey;
    case FriendsStateType.appUserFriended:
      return Colors.blue;
    default:
      return Colors.white;
  }
}

String mainButtonText(FriendsStateType addFriendsStateType) {
  switch (addFriendsStateType) {
    case FriendsStateType.notAppUser:
      return "招待";
    case FriendsStateType.appUserNoRelationship:
      return "追加";
    case FriendsStateType.appUserApplication:
      return "申請中";
    case FriendsStateType.appUserReceivedApplication:
      return "許可";
    case FriendsStateType.appUserFriended:
      return "追加済";
  }
}

VoidCallback? mainButtonTapEvent(
  BuildContext context,
  WidgetRef ref,
  FriendsStateType addFriendsStateType,
  ValueNotifier<bool> isLoading,
  OnContactListType onContactListType,
  ValueNotifier<List<String>?> applyingList,
  UserType myProfile,
) {
  if (addFriendsStateType == FriendsStateType.notAppUser) {
    return () => sendSMSMessage(onContactListType.phoneNumber, isLoading);
  }
  if (addFriendsStateType == FriendsStateType.appUserNoRelationship) {
    return () => friendRequest(
          context,
          isLoading,
          applyingList,
          onContactListType,
          myProfile,
        );
  }
  if (addFriendsStateType == FriendsStateType.appUserReceivedApplication) {
    return () => friendRequestPermission(
          context,
          ref,
          isLoading,
          onContactListType,
          myProfile,
        );
  }
  return null;
}

Future<void> sendSMSMessage(
  String phoneNumber,
  ValueNotifier<bool> isLoading,
) async {
  isLoading.value = true;
  await sendSMS(
    message: "LiLi-appをダウンローどして、日常を共有する友達になりませんか？https://test",
    recipients: [phoneNumber],
  );
  isLoading.value = false;
}

Future<void> friendRequest(
  BuildContext context,
  ValueNotifier<bool> isLoading,
  ValueNotifier<List<String>?> applyingList,
  OnContactListType onContactListType,
  UserType myProfile,
) async {
  final userData = onContactListType.userData;
  if (userData == null) return;
  isLoading.value = true;
  final isRequest =
      await dbFirestoreFriendRequest(userData.openId, myProfile.openId);
  if (!context.mounted) return;
  if (!isRequest) {
    errorAlertDialog(context, subTitle: eMessageSystem);
    return;
  }

  applyingList.value = [
    ...applyingList.value ?? [],
    userData.openId,
  ];
  await localWriteList(applyingList.value ?? []);

  isLoading.value = false;
}

Future<void> friendRequestPermission(
  BuildContext context,
  WidgetRef ref,
  ValueNotifier<bool> isLoading,
  OnContactListType onContactListType,
  UserType myProfile,
) async {
  final userData = onContactListType.userData;
  if (userData == null) return;
  isLoading.value = true;
  final isRequest = await dbFirestoreFriendRequestPermission(
    userData.openId,
    myProfile.openId,
  );
  if (!context.mounted) return;
  if (!isRequest) {
    errorAlertDialog(context, subTitle: eMessageSystem);
    return;
  }
  final allRequestFriendsNotifier =
      ref.read(allRequestFriendsNotifierProvider.notifier);
  await allRequestFriendsNotifier.delete(userData.openId);
  isLoading.value = false;
}
