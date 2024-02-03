import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/img.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/widget/profile_widgets/my_profile_widget.dart';

class FullScreenFriendPage extends HookConsumerWidget {
  const FullScreenFriendPage({super.key, required this.userData});
  final UserType userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
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
                  borderRadius: 0,
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
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: xPadding(context),
                          child: Row(
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
                              Padding(
                                padding: customPadding(
                                  left: safeAreaWidth * 0.03,
                                ),
                                child: nContainer(
                                  padding: EdgeInsets.all(safeAreaWidth * 0.01),
                                  border: mainBorder(color: subColor, width: 3),
                                  isCircle: true,
                                  color: Colors.white,
                                  child: nText(
                                    userData.toDayMood ?? "",
                                    fontSize: safeAreaWidth / 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ...todayPostWidget(context, userData),
          ],
        ),
      ),
    );
  }
}
