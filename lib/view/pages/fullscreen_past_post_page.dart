import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/data_format_utility.dart';

class FullScreenPastPostPage extends HookConsumerWidget {
  const FullScreenPastPostPage({
    super.key,
    required this.postListData,
  });
  final PastPostListType postListData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final postList = postListData.toNonNullList();
    final index = useState<int>(0);
    final String postDate = formattedDate(postList[index.value].postDateTime);
    final String postTime = formattedTime(postList[index.value].postDateTime);
    return imgWidget(
      size: double.infinity,
      fileData: File(postList[index.value].postImgPath),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 100.0,
            sigmaY: 100.0,
          ),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.7),
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
                Padding(
                  padding: EdgeInsets.all(safeAreaWidth * 0.04),
                  child: Column(
                    children: [
                      Padding(
                        padding: customPadding(
                          bottom: safeAreaHeight * 0.05,
                          top: safeAreaHeight * 0.02,
                        ),
                        child: Row(
                          children: [
                            for (int i = 0; i < postList.length; i++) ...{
                              Expanded(
                                child: nContainer(
                                  height: 4,
                                  radius: 50,
                                  color: i == index.value
                                      ? Colors.white
                                      : Colors.grey.withOpacity(
                                          0.5,
                                        ),
                                ),
                              ),
                              if (i != postList.length - 1)
                                SizedBox(
                                  width: safeAreaWidth * 0.02,
                                ),
                            },
                          ],
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 3 / 4,
                        child: imgWidget(
                          borderRadius: 30,
                          color: subColor,
                          boxShadow: mainBoxShadow(),
                          fileData: File(postList[index.value].postImgPath),
                          child: postList[index.value].doing != null
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
                                      postList[index.value].doing!,
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
                      Expanded(
                        child: Padding(
                          padding: xPadding(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (int i = 0; i < 2; i++)
                                Opacity(
                                  opacity: [
                                    if (index.value == 0) 0.1 else 1.0,
                                    if (index.value == postList.length - 1)
                                      0.1
                                    else
                                      1.0,
                                  ][i],
                                  child: Icon(
                                    [Icons.arrow_back, Icons.arrow_forward][i],
                                    color: Colors.white,
                                    size: safeAreaWidth / 10,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    for (int i = 0; i < 2; i++)
                      Expanded(
                        child: GestureDetector(
                          onTap: [
                            if (0 != index.value) () => index.value-- else null,
                            if (postList.length - 1 != index.value)
                              () => index.value++
                            else
                              null,
                          ][i],
                          child: Container(
                            height: double.infinity,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
