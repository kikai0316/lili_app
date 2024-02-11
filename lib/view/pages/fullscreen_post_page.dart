import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/data_format_utility.dart';

class FullScreenPostPage extends HookConsumerWidget {
  const FullScreenPostPage({
    super.key,
    required this.userData,
    required this.postData,
  });
  final UserType userData;
  final PostType? postData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final String postDate =
        postData != null ? formattedDate(postData!.postDateTime) : "投稿がありません";
    final String postTime =
        postData != null ? formattedTime(postData!.postDateTime) : "";
    return imgWidget(
      size: double.infinity,
      networkUrl: postData?.postImg,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 100.0,
            sigmaY: 100.0,
          ),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.7),
            extendBodyBehindAppBar: true,
            appBar: nAppBar(
              context,
              customTitle: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 2; i++)
                    Padding(
                      padding: customPadding(
                        bottom: i == 0 ? safeAreaHeight * 0.01 : 0,
                      ),
                      child: nText(
                        [postDate, postTime][i],
                        fontSize: safeAreaWidth / [20, 30][i],
                        color: [Colors.white, Colors.grey][i],
                      ),
                    ),
                ],
              ),
              leftIconType: BackIconStyleType.arrowBackBottomIcon,
            ),
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: nContainer(
                      alignment: Alignment.bottomCenter,
                      height: safeAreaHeight / 2,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Padding(
                        padding: customPadding(bottom: safeAreaHeight * 0.1),
                        child: nText(
                          "タップでもどる",
                          fontSize: safeAreaWidth / 20,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: Padding(
                    padding: EdgeInsets.all(safeAreaWidth * 0.03),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: imgWidget(
                        borderRadius: 30,
                        color: subColor,
                        boxShadow: mainBoxShadow(),
                        networkUrl: postData?.postImg,
                        child: postData?.doing != null
                            ? Padding(
                                padding: EdgeInsets.all(safeAreaWidth * 0.03),
                                child: nContainer(
                                  padding: xPadding(
                                    context,
                                    xSize: safeAreaWidth * 0.04,
                                    top: safeAreaWidth * 0.02,
                                    bottom: safeAreaWidth * 0.02,
                                  ),
                                  color: Colors.black.withOpacity(0.6),
                                  radius: 50,
                                  child: nText(
                                    postData?.doing ?? "",
                                    fontSize: safeAreaWidth / 30,
                                    textAlign: TextAlign.right,
                                    bold: 700,
                                    maxLiune: 2,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
