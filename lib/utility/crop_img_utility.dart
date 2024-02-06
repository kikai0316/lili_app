import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

Future<File?> cropProfileImg(File img) async {
  final ImageCropper cropper = ImageCropper();
  final CroppedFile? croppedFile = await cropper.cropImage(
    sourcePath: img.path,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ],
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: '',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      IOSUiSettings(
        title: '',
        rectX: 50,
        rectY: 50,
        rectWidth: 5000,
        rectHeight: 5000,
        aspectRatioLockEnabled: true,
        aspectRatioPickerButtonHidden: true,
        doneButtonTitle: "完了",
        cancelButtonTitle: "キャンセル",
      ),
    ],
  );

  if (croppedFile != null) {
    return File(croppedFile.path);
  } else {
    return null;
  }
}
