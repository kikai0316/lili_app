import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/utility/firebase/firebase_storage_utility.dart';
import 'package:lili_app/utility/type_updata_utility.dart';
import 'package:lili_app/utility/utility.dart';
import 'package:lili_app/view_model/user_data.dart';
import 'package:lili_app/widget/profile_widgets/edit_profile_widget.dart';

class EditProfilePage extends HookConsumerWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataState = ref.watch(userDataNotifierProvider);
    final isDataReady = userDataState is AsyncData<UserType?>;
    final UserType? userData = userDataState.value;
    final isLoading = useState<bool>(false);
    if (userData == null) {
      return const SizedBox();
    }
    return Stack(
      children: [
        Scaffold(
          backgroundColor: mainBackGroundColor,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          appBar: nAppBar(
            context,
            title: "プロフィール編集",
          ),
          body: isDataReady
              ? SafeArea(
                  child: Padding(
                    padding: xPadding(context),
                    child: Center(
                      child: Column(
                        children: [
                          editImgWidget(
                            context,
                            img: userData.img,
                            onTap: () => profileImgTapEvent(
                              context,
                              ref,
                              userData,
                              isLoading,
                            ),
                          ),
                          editBasicWidget(
                            context,
                            userData: userData,
                            onBirthdayTapEvent: () => birthdayTapEvent(
                              context,
                              ref,
                              userData,
                              isLoading,
                            ),
                          ),
                        ],
                      ),
                    ),
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

  Future<void> profileImgTapEvent(
    BuildContext context,
    WidgetRef ref,
    UserType userData,
    ValueNotifier<bool> isLoading,
  ) async {
    Future<void> selectImage() async {
      try {
        final getImg = await getMobileImage(context, isLoading);
        if (!context.mounted) return;
        if (getImg == null) return;
        isLoading.value = true;
        final url =
            await dbStorageProfileImgUpload(id: userData.openId, img: getImg);
        await dbFirestoreUpDataData(userData.openId, {"user_img": url});
        final userDataNotifier = ref.watch(userDataNotifierProvider.notifier);
        await userDataNotifier.userDataUpDate(
          userTypeUpDate(userData, isImg: true, img: url),
        );
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;
      }
    }

    Future<void> deleteImage() async {
      if (userData.img == null) return;
      isLoading.value = true;
      await dbStorageProfileImgDelete(userData.openId);
      await dbFirestoreUpDataData(
        userData.openId,
        {"user_img": FieldValue.delete()},
      );
      final userDataNotifier = ref.watch(userDataNotifierProvider.notifier);
      await userDataNotifier.userDataUpDate(
        userTypeUpDate(userData, isImg: true),
      );
      if (!context.mounted) return;
      isLoading.value = false;
    }

    showBottomMenu(
      context,
      itemList: [
        BottomMenuItemType(
          onTap: () => selectImage(),
          text: "カメラロールから選択",
        ),
        BottomMenuItemType(
          onTap: () => deleteImage(),
          text: "画像削除",
          color: Colors.red,
        ),
      ],
    );
  }

  Future<void> birthdayTapEvent(
    BuildContext context,
    WidgetRef ref,
    UserType userData,
    ValueNotifier<bool> isLoading,
  ) async {
    final selectDate = await showBottomDatePicker(
      context,
    );
    if (selectDate == null) return;
    isLoading.value = true;
    await dbFirestoreUpDataData(userData.openId, {"birthday": selectDate});
    final userDataNotifier = ref.read(userDataNotifierProvider.notifier);
    await userDataNotifier
        .userDataUpDate(userTypeUpDate(userData, birthday: selectDate));
    if (!context.mounted) return;
    isLoading.value = false;
  }
}
