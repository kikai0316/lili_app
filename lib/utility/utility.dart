import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/message.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/crop_img_utility.dart';
import 'package:lili_app/utility/data_format_utility.dart';
import 'package:lili_app/utility/notistack_utility.dart';
import 'package:lili_app/utility/permission_utlity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

Future openURL({
  required String url,
  VoidCallback? onError,
  VoidCallback? onThen,
}) async {
  final Uri setURL = Uri.parse(url);
  try {
    if (await canLaunchUrl(setURL)) {
      await launchUrl(setURL, mode: LaunchMode.inAppWebView)
          .then((value) => onThen?.call());
    } else {
      onError?.call();
    }
  } catch (e) {
    onError?.call();
  }
}

void bottomSheet(
  BuildContext context, {
  required Widget page,
  VoidCallback? onThen,
  VoidCallback? onError,
  Color? barrierColor,
}) =>
    showModalBottomSheet<Widget>(
      isScrollControlled: true,
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      builder: (context) => page,
    )
        .then((value) => onThen?.call())
        .onError((error, stackTrace) => onError?.call());

Future<File?> getMobileImage(
  BuildContext context,
  ValueNotifier<bool> isLoading,
) async {
  void errorShowDialog(bool isPermission) {
    isLoading.value = false;
    showAlertDialog(
      context,
      title: "カメラへのアクセス権がありません。",
      subTitle: !isPermission ? eMessageNotPhotoPermission : eMessagePhoto,
      rightButtonText: !isPermission ? "設定画面へ" : null,
      leftButtonText: "キャンセル",
      rightButtonOnTap: !isPermission ? () => openAppSettings() : null,
    );
  }

  isLoading.value = true;
  final isPermission = await checkPhotoPermission();
  if (!isPermission && context.mounted) {
    errorShowDialog(false);
    return null;
  }
  try {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      isLoading.value = false;
      return null;
    }
    final File file = File(pickedFile.path);
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      "${file.absolute.path}_bubu.jpg",
      quality: 50,
    );
    if (compressedFile == null) {
      errorShowDialog(true);
      return null;
    }
    final isCrop = await cropProfileImg(File(compressedFile.path));
    isLoading.value = false;
    return isCrop;
  } catch (e) {
    errorShowDialog(true);
    return null;
  }
}

Future<void> showBottomMenu(
  BuildContext context, {
  required List<BottomMenuItemType> itemList,
  int? selectIndex,
}) async {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  bool isSelect(int index) => selectIndex != null || selectIndex == index;
  await showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      actions: List.generate(
        itemList.length,
        (i) => ColoredBox(
          color: Colors.white,
          child: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(
                context,
              );
              itemList[i].onTap();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSelect(i))
                  Padding(
                    padding: EdgeInsets.only(right: safeAreaWidth * 0.01),
                    child: Icon(
                      Icons.done,
                      color: itemList[i].color ?? Colors.blue,
                      size: safeAreaWidth / 20,
                    ),
                  ),
                nText(
                  itemList[i].text,
                  color: itemList[i].color ?? Colors.blue,
                  fontSize: safeAreaWidth / 27,
                  bold: 700,
                ),
              ],
            ),
          ),
        ),
      ),
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () => Navigator.pop(
          context,
        ),
        child: nText(
          "キャンセル",
          color: Colors.blue,
          fontSize: safeAreaWidth / 25,
          bold: 700,
        ),
      ),
    ),
  );
}

Future<String?> showBottomDatePicker(
  BuildContext context, {
  String? initData,
}) async {
  DateTime? selectData;
  final currentTime = initData != null
      ? DateFormat('yyyy/MM/dd').parse(initData)
      : getTwentyYearsAgoJanFirst();
  await DatePicker.showDatePicker(
    context,
    minTime: DateTime(1950),
    maxTime: DateTime(2022, 8, 17),
    currentTime: currentTime,
    locale: LocaleType.jp,
    onConfirm: (date) => selectData = date,
  );
  if (selectData == null) return null;
  return DateFormat('yyyy/MM/dd').format(selectData!);
}
