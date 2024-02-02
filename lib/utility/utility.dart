import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lili_app/constant/message.dart';
import 'package:lili_app/utility/crop_img_utility.dart';
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
      quality: 80,
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
