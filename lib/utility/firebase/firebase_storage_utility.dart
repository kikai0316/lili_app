import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String?> dbStorageProfileImgUpload({
  required String id,
  required File img,
}) async {
  final storageRef = FirebaseStorage.instance.ref("users/$id");
  try {
    await dbStorageProfileImgDelete(id);
    final mountainsRef = storageRef.child(
      "${DateTime.now()}",
    );
    await mountainsRef.putFile(img);
    return mountainsRef.getDownloadURL();
  } catch (e) {
    return null;
  }
}

Future<void> dbStorageProfileImgDelete(String id) async {
  final storageRef = FirebaseStorage.instance.ref("users/$id");
  try {
    await storageRef.listAll().then(
          (result) =>
              Future.forEach<Reference>(result.items, (ref) => ref.delete()),
        );
  } catch (e) {
    return;
  }
}
