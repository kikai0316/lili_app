import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/img.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/path_provider_utility.dart';
import 'package:lili_app/widget/on_item/on_add_friend_widget.dart';
import 'package:lili_app/widget/profile_widgets/my_profile_widget.dart';

class FullScreenFriendPage extends HookConsumerWidget {
  const FullScreenFriendPage(
      {super.key,
      required this.userData,
      required this.friendsStateType,
      required this.myProfile,});
  final UserType userData;
  final FriendsStateType friendsStateType;
  final UserType myProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final applyingList = useState<List<String>?>(null);
    final isLoading = useState<bool>(false);
    useEffect(
      () {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Future(() async {
            if (applyingList.value != null) return;
            final getApplyingList = await localReadList();
            if (!context.mounted) return;
            applyingList.value = getApplyingList;
          });
        });
        return null;
      },
      [applyingList],
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: mainBackGroundColor,
        extendBodyBehindAppBar: true,
        appBar: nAppBar(
          context,
          leftIconType: BackIconStyleType.arrowBackBottomIcon,
        ),
        body: Column(
          children: [
            Padding(
              padding: customPadding(bottom: safeAreaHeight * 0.07),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: imgWidget(
                  borderRadius: 15,
                  networkUrl: userData.img,
                  assetFile: notImg(userData.img),
                  child: Stack(
                    children: [
                      for (int i = 0; i < 2; i++)
                        Align(
                          alignment: [
                            Alignment.topCenter,
                            Alignment.bottomCenter,
                          ][i],
                          child: nContainer(
                            width: safeAreaWidth,
                            height: safeAreaHeight * 0.15,
                            gradient: mainGradationWithBlackOpacity(
                              startOpacity: [0.6, 1.0][i],
                              begin: [
                                FractionalOffset.topCenter,
                                FractionalOffset.bottomCenter,
                              ][i],
                              end: [
                                FractionalOffset.bottomCenter,
                                FractionalOffset.topCenter,
                              ][i],
                            ),
                          ),
                        ),
                      Padding(
                        padding: xPadding(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                nContainer(
                                  maxWidth: safeAreaWidth * 0.8,
                                  child: nText(
                                    userData.name,
                                    isOverflow: false,
                                    textAlign: TextAlign.left,
                                    fontSize: safeAreaWidth / 15,
                                  ),
                                ),
                                if ((userData.toDayMood ?? "").isNotEmpty)
                                  Padding(
                                    padding: customPadding(
                                      left: safeAreaWidth * 0.03,
                                    ),
                                    child: nContainer(
                                      padding:
                                          EdgeInsets.all(safeAreaWidth * 0.01),
                                      border:
                                          mainBorder(color: subColor, width: 3),
                                      isCircle: true,
                                      color: Colors.white,
                                      child: nText(
                                        textAlign: TextAlign.left,
                                        userData.toDayMood ?? "",
                                        fontSize: safeAreaWidth / 15,
                                        isOverflow: false,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Padding(
                              padding:
                                  customPadding(top: safeAreaHeight * 0.02),
                              child: nText(
                                userData.comment ?? "",
                                textAlign: TextAlign.left,
                                fontSize: safeAreaWidth / 30,
                                bold: 700,
                                height: 1.3,
                                isOverflow: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (friendsStateType == FriendsStateType.appUserFriended) ...{
              ...todayPostWidget(context, userData),
            } else ...{
              Padding(
                padding: xPadding(context),
                child: mainButton(
                  context,
                  borderColor: Colors.white.withOpacity(0.3),
                  backGroundColor: mainButtonBackGroundColor(friendsStateType),
                  text: mainButtonText(friendsStateType),
                  textColor: mainButtonTextColor(friendsStateType),
                  onTap: mainButtonTapEvent(
                    context,
                    ref,
                    friendsStateType,
                    isLoading,
                    OnContactListType(
                      phoneNumber: userData.phoneNumber,
                      userData: userData,
                    ),
                    applyingList,
                    myProfile,
                  ),
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}
