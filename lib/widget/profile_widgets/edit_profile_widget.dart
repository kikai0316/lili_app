import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/img.dart';
import 'package:lili_app/model/model.dart';

Widget editImgWidget(
  BuildContext context, {
  required File? editImg,
  required VoidCallback onTap,
  required String? defaultImg,
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
        fileData: editImg,
        networkUrl: defaultImg,
        assetFile: editImg == null ? notImg(defaultImg) : null,
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

Widget editBasicWidget(BuildContext context, List<String> dataList) {
  return Padding(
    padding: yPadding(context),
    child: nListTile(
      context,
      List.generate(
        2,
        (i) => NListTileItemType(
          leftTitle: ["ユーザー名", "生年月日"][i],
          dataText: dataList[i],
          onTap: [
            () {
              // bottomSheet(
              //   context,
              //   page: StringEditSheet(
              //     title: "ユーザー名",
              //     initData: dataList[i],
              //     onTap: (value) => editName.value = value,
              //   ),
              // );
            },
            () async {
              // final selectDate = await showBottomDatePicker(
              //   context,
              // );
              // if (selectDate != null) {
              //   editBirthday.value = formatDateTimeToBirthdayString(
              //     selectDate,
              //     false,
              //   );
              // }
            }
          ][i],
        ),
      ),
    ),
  );
}

Widget editTodayMoodWidget(BuildContext context, String data) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: customPadding(top: safeAreaHeight * 0.02),
    child: CustomAnimatedOpacityButton(
      opacity: 0.5,
      onTap: () {},
      child: nContainer(
        color: subColor,
        padding: xPadding(context),
        height: safeAreaHeight * 0.08,
        radius: 15,
        child: Row(
          children: [
            nText(
              "今日の気分",
              fontSize: safeAreaWidth / 27,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: nText(
                  data,
                  fontSize: safeAreaWidth / 15,
                ),
              ),
            ),
            Padding(
              padding: customPadding(left: safeAreaWidth * 0.03),
              child: Icon(
                Icons.arrow_forward_ios,
                size: safeAreaWidth / 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
