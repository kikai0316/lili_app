import 'package:flutter/material.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/constant.dart';

Widget postIconWidget(BuildContext context) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return SafeArea(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: nContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            nText(
              "次の投稿まで",
              fontSize: safeAreaWidth / 35,
              shadows: mainBoxShadow(
                shadow: 1,
              ),
            ),
            nText(
              "50:01",
              fontSize: safeAreaWidth / 10,
              shadows: mainBoxShadow(
                shadow: 1,
              ),
            ),

            // nContainer(
            //   padding: EdgeInsets.all(safeAreaWidth * 0.06),
            //   alignment: Alignment.center,
            //   height: safeAreaHeight * 0.085,
            //   width: safeAreaHeight * 0.085,
            //   radius: 20,
            //   color: Colors.grey,
            //   child: Stack(
            //     alignment: Alignment.center,
            //     children: [
            //       for (int i = 0; i < 2; i++)
            //         nContainer(
            //           height: i == 0 ? safeAreaWidth * 0.01 : double.infinity,
            //           width: i == 1 ? safeAreaWidth * 0.01 : double.infinity,
            //           color: Colors.black,
            //           radius: 50,
            //         ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    ),
  );
}

PreferredSizeWidget? initialPageAppBar(
  BuildContext context,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return nAppBar(
    context,
    customLeftIcon: nContainer(
      padding: EdgeInsets.all(safeAreaWidth * 0.013),
      height: safeAreaWidth * 0.11,
      width: safeAreaWidth * 0.11,
      child: imgWidget(assetFile: "friend_icon.png"),
    ),
    customTitle: nText(
      "RoyalHy",
      fontSize: safeAreaWidth / 14,
    ),
    customRightIcon: imgWidget(
      size: safeAreaWidth * 0.09,
      border: mainBorder(),
      networkUrl:
          "https://i.pinimg.com/474x/c3/43/2b/c3432b9ca4f20b5dc85a634df3f07274.jpg",
      isCircle: true,
    ),
  );
}
