import 'dart:io';

import 'package:flutter/material.dart';

DecorationImage notImg() {
  return const DecorationImage(
    image: AssetImage("assets/img/not.png"),
    fit: BoxFit.cover,
  );
}

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
