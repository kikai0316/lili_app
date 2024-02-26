import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/utility/firebase/firebase_storage_utility.dart';
import 'package:lili_app/utility/type_updata_utility.dart';
import 'package:lili_app/utility/utility.dart';
import 'package:lili_app/view/profile_pages/other_setting_sheet.dart';
import 'package:lili_app/view_model/all_past_post.dart';
import 'package:lili_app/view_model/user_data.dart';
import 'package:lili_app/widget/profile_widgets/my_profile_widget.dart';

class MyProfilePage extends HookConsumerWidget {
  const MyProfilePage({
    super.key,
    required this.userData,
    required this.isLoading,
  });
  final UserType userData;
  final ValueNotifier<bool> isLoading;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final allPadtPostState = ref.watch(allPastPostNotifierProvider);

    return Scaffold(
      backgroundColor: mainBackGroundColor,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: nAppBar(
        context,
        title: "プロフィール",
        leftIconType: null,
        customRightIcon: CustomAnimatedOpacityButton(
          onTap: () => bottomSheet(
            context,
            page: OtherSettingSheet(
              isLoading: isLoading,
            ),
          ),
          child: Icon(
            Icons.more_horiz,
            color: Colors.white,
            size: safeAreaWidth / 15,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myProfileMainWidget(
                context,
                userData,
                onRefresh: () => reFetch(ref, userData, isLoading),
              ),
              ...todayPostWidget(context, userData),
              ...pastPostWidget(context, allPadtPostState),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> reFetch(
    WidgetRef ref,
    UserType myProfile,
    ValueNotifier<bool> isLoading,
  ) async {
    isLoading.value = true;
    final profileData = await dbFirestoreReadUser(myProfile.openId);
    if (profileData == null) return;
    final postData =
        await dbStoragePostDownload(id: profileData.openId) ?? PostListType();
    final userData = ref.read(userDataNotifierProvider.notifier);
    final allPastPostNotifier = ref.read(allPastPostNotifierProvider.notifier);
    final setUserData = userTypeUpDate(profileData, postListType: postData);
    await userData.userDataUpDate(setUserData);
    await allPastPostNotifier.reFetch();
    isLoading.value = false;
  }
}
