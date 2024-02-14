import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
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
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final userDataState = ref.watch(userDataNotifierProvider);
    final allPadtPostState = ref.watch(allPastPostNotifierProvider);
    final isLoading = useState<bool>(false);
    final isDataReady = userDataState is AsyncData<UserType?>;
    final UserType? userData = userDataState.value;
    if (userData == null) {
      return nText("エラー", fontSize: safeAreaWidth / 20);
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: mainBackGroundColor,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          appBar: nAppBar(
            context,
            title: "プロフィール",
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
          body: isDataReady
              ? SafeArea(
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
                )
              : loadinPage(
                  context: context,
                ),
        ),
        loadinPage(context: context, isLoading: isLoading.value),
      ],
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
