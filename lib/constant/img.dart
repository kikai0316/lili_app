import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lili_app/constant/constant.dart';

DecorationImage assetImg(String file) {
  return DecorationImage(
    image: AssetImage("assets/img/$file"),
    fit: BoxFit.cover,
  );
}

DecorationImage networkImg(String url) {
  return DecorationImage(
    image: NetworkImage(url),
    fit: BoxFit.cover,
  );
}

DecorationImage fileImg(File fileData) {
  return DecorationImage(
    image: FileImage(fileData),
    fit: BoxFit.cover,
  );
}

DecorationImage memorImg(Uint8List memorImg) {
  return DecorationImage(
    image: MemoryImage(memorImg),
    fit: BoxFit.cover,
  );
}

String? notImg() {
  return "not.png";
}

Widget logoWidget(
  BuildContext context,
) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Container(
    height: safeAreaHeight * 0.025,
    width: safeAreaWidth * 0.25,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/img/logo2.png"),
        fit: BoxFit.fitWidth,
      ),
    ),
  );
  // imgWidget(size: size, assetFile: "logo2.png");
}
