import 'package:flutter/material.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/widget/on_item/on_add_friend_widget.dart';

PreferredSizeWidget? addFriendAppBar(
  BuildContext context,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return nAppBar(
    context,
    title: "友達を探す",
    leftIconType: null,
    customRightIcon: nContainer(
      alignment: Alignment.centerRight,
      width: safeAreaWidth * 0.11,
      child: CustomAnimatedOpacityButton(
        onTap: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
          size: safeAreaWidth / 14,
        ),
      ),
    ),
  );
}

Widget addFriendTextField(
  BuildContext context,
  TextEditingController? textController,
  ValueNotifier<bool> isCancelIcon,
  ValueNotifier<bool> isSearch,
  ValueNotifier<List<UserType>?> searchResults,
) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: yPadding(context, ySize: safeAreaHeight * 0.01),
    child: nContainer(
      padding: xPadding(context),
      height: safeAreaHeight * 0.065,
      width: safeAreaWidth,
      color: subColor,
      radius: 15,
      child: Row(
        children: [
          Opacity(
            opacity: 0.5,
            child: Padding(
              padding: customPadding(right: safeAreaWidth * 0.02),
              child: imgWidget(
                size: safeAreaHeight * 0.03,
                assetFile: "search_icon.png",
              ),
            ),
          ),
          Expanded(
            child: nTextFormField(
              context,
              autofocus: false,
              textController: textController,
              keyboardType: TextInputType.text,
              fontSize: safeAreaWidth / 25,
              hintText: "ユーザーID、電話番号",
              onChanged: (value) => isCancelIcon.value = value.isNotEmpty,
              onFieldSubmitted: (value) async {
                searchResults.value = null;
                isSearch.value = true;
                final searchDataList = await dbFirestoreSearchUser(value);
                if (!context.mounted) return;
                searchResults.value = searchDataList;
              },
            ),
          ),
          if (isCancelIcon.value)
            iconButtonWithCancel(
              context,
              size: safeAreaWidth / 20,
              customOnTap: () {
                textController?.clear();
                searchResults.value = null;
                isSearch.value = false;
                isCancelIcon.value = false;
              },
            ),
        ],
      ),
    ),
  );
}

Widget addFriendLists(
  BuildContext context, {
  required UserType myProfile,
  required ContactListType? contactList,
  required ValueNotifier<List<String>?> applyingList,
  required bool isDataReady,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final appUserList = contactList?.appUserList ?? [];
  final contactUserList = contactList?.contactUserList ?? [];
  if (!isDataReady) {
    return Padding(
      padding: customPadding(top: safeAreaHeight * 0.04),
      child: nIndicatorWidget(safeAreaWidth / 30),
    );
  }
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: yPadding(context),
          child: nText("RoyalHayユーザーのお友達", fontSize: safeAreaWidth / 30),
        ),
        ...appUserList.map(
          (item) => OnAddFriend(
            onAddFriendType: item,
            applyingList: applyingList,
            myProfile: myProfile,
          ),
        ),
        if (appUserList.isEmpty)
          nText(
            "現在、RoyalHayにはまだお友達がいません。",
            fontSize: safeAreaWidth / 33,
            color: Colors.grey.withOpacity(0.5),
            bold: 700,
            height: 1.2,
            isOverflow: false,
          ),
        Padding(
          padding: yPadding(context),
          child: nText("連絡先のお友達を招待", fontSize: safeAreaWidth / 30),
        ),
        ...contactUserList.map(
          (item) => OnAddFriend(
            onAddFriendType: item,
            applyingList: applyingList,
            myProfile: myProfile,
          ),
        ),
        SizedBox(
          height: safeAreaHeight * 0.1,
        ),
      ],
    ),
  );
}

Widget addFriendSearchList(
  BuildContext context, {
  required UserType myProfile,
  required ValueNotifier<List<UserType>?> searchResults,
  required ValueNotifier<List<String>?> applyingList,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return SingleChildScrollView(
    child: Column(
      children: [
        Padding(
          padding: yPadding(context),
          child: nText(
            "検索結果：${((searchResults.value ?? []).isEmpty) ? "０件" : ""}",
            fontSize: safeAreaWidth / 30,
          ),
        ),
        if (searchResults.value == null)
          Padding(
            padding: customPadding(top: safeAreaHeight * 0.04),
            child: Align(child: nIndicatorWidget(safeAreaWidth / 30)),
          ),
        ...(searchResults.value ?? []).map(
          (item) => OnAddFriend(
            onAddFriendType: OnContactListType(
              phoneNumber: item.phoneNumber,
              userData: item,
            ),
            applyingList: applyingList,
            myProfile: myProfile,
          ),
        ),
        SizedBox(
          height: safeAreaHeight * 0.1,
        ),
      ],
    ),
  );
}

Widget friendRequestLists(
  BuildContext context, {
  required UserType myProfile,
  required List<UserType>? userList,
  required ValueNotifier<List<String>?> applyingList,
  required bool isDataReady,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final requestUsers = userList ?? [];
  if (!isDataReady) {
    return Padding(
      padding: customPadding(top: safeAreaHeight * 0.04),
      child: nIndicatorWidget(safeAreaWidth / 30),
    );
  }
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(
          height: safeAreaHeight * 0.03,
        ),
        ...requestUsers.map(
          (item) => OnAddFriend(
            onAddFriendType: OnContactListType(
              phoneNumber: item.phoneNumber,
              userData: item,
            ),
            applyingList: applyingList,
            myProfile: myProfile,
          ),
        ),
        if (requestUsers.isEmpty)
          Padding(
            padding: yPadding(context, ySize: safeAreaHeight * 0.05),
            child: nText(
              "フレンドリクエストはありません。",
              fontSize: safeAreaWidth / 25,
              height: 1.2,
              isOverflow: false,
            ),
          ),
      ],
    ),
  );
}
