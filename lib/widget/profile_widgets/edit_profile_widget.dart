import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/img.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/view/profile_pages/on_edith_page.dart';

Widget editImgWidget(
  BuildContext context, {
  required VoidCallback onTap,
  required String? img,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return Padding(
    padding: yPadding(context),
    child: CustomAnimatedOpacityButton(
      onTap: onTap,
      child: imgWidget(
        size: safeAreaHeight * 0.15,
        isCircle: true,
        networkUrl: img,
        assetFile: notImg(),
        color: subColor,
        child: nContainer(
          border: mainBorder(color: mainBackGroundColor, width: 4),
          padding: EdgeInsets.all(
            safeAreaWidth * 0.015,
          ),
          color: Colors.white,
          isCircle: true,
          child: Icon(
            Icons.photo_camera,
            color: Colors.black.withOpacity(0.8),
            size: safeAreaWidth / 17,
          ),
        ),
      ),
    ),
  );
}

Widget editBasicWidget(
  BuildContext context, {
  required UserType userData,
  required VoidCallback onBirthdayTapEvent,
}) {
  final titleList = ["名前", "ユーザー名", "ひとこと", "生年月日", "電話番号"];
  final dataList = [
    userData.name,
    userData.userId,
    userData.comment,
    userData.birthday ?? "",
    userData.phoneNumber,
  ];
  return Padding(
    padding: yPadding(context),
    child: nListTile(
      context,
      List.generate(
        titleList.length,
        (i) => NListTileItemType(
          leftTitle: titleList[i],
          dataText: dataList[i].isNotEmpty ? dataList[i] : "未設定",
          isOpacity: i == 4,
          onTap: i != 4
              ? i != 3
                  ? () => ScreenTransition(
                        context,
                        OnEditPage(
                          title: titleList[i],
                          initData: dataList[i],
                          userData: userData,
                        ),
                      ).normal()
                  : () => onBirthdayTapEvent()
              : null,
        ),
      ),
    ),
  );
}
