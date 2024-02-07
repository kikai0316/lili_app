import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/data_format_utility.dart';

final storage = FirebaseStorage.instance;
Future<String?> dbStorageProfileImgUpload({
  required String id,
  required File img,
}) async {
  final storageRef = storage.ref("users/$id");
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
  final storageRef = storage.ref("users/$id");
  try {
    await storageRef.listAll().then(
          (result) =>
              Future.forEach<Reference>(result.items, (ref) => ref.delete()),
        );
  } catch (e) {
    return;
  }
}

Future<String?> dbStoragePostUpload({
  required DateTime nowTime,
  required String id,
  required File img,
  required String nowState,
  required VoidCallback onTimeOut,
  required VoidCallback onError,
}) async {
  final postTime = getPostTimeType(nowTime);
  if (postTime == null) {
    onTimeOut();
    return null;
  }
  final deleteList = getPostTimeTypesAfterIncluding(postTime);
  final storageRef = storage.ref("users/$id/posts");
  try {
    await storageRef.listAll().then((result) {
      for (final item in result.items) {
        final List<String> parts = item.name.split('@');
        if (parts.length == 2) {
          final getDataTime = DateTime.parse(parts.first);
          final postTime = getPostTimeType(getDataTime);
          if (postTime != null) {
            if (deleteList.contains(postTime)) {
              item.delete();
            }
          } else {
            item.delete();
          }
        } else {
          item.delete();
        }
      }
    });

    final mountainsRef = storageRef.child(
      "$nowTime@$nowState",
    );
    await mountainsRef.putFile(img);
    return mountainsRef.getDownloadURL();
  } catch (e) {
    onError();
    return null;
  }
}

Future<String?> dbStorageWakeUpPostUpload({
  required String id,
  required File img,
  required VoidCallback onError,
}) async {
  final now = DateTime.now();
  final storageRef = storage.ref("users/$id/wakeup");
  try {
    await storage.ref("users/$id/posts").listAll().then(
          (result) =>
              Future.forEach<Reference>(result.items, (ref) => ref.delete()),
        );
    await storageRef.listAll().then(
          (result) =>
              Future.forEach<Reference>(result.items, (ref) => ref.delete()),
        );
    final mountainsRef = storageRef.child(
      "$now",
    );
    await mountainsRef.putFile(img);
    return mountainsRef.getDownloadURL();
  } catch (e) {
    onError();
    return null;
  }
}

Future<PostListType?> dbStoragePostDownload({
  required String id,
}) async {
  final List<PostType> dataList = [];
  try {
    final getWakeupList = await storage.ref("users/$id/wakeup").listAll();
    if (getWakeupList.items.isEmpty) return PostListType();
    final getWakeup = getWakeupList.items.first;
    final getWakeupDataString = DateTime.parse(getWakeup.name);
    if (!isAfterThreeAM(getWakeupDataString)) {
      await getWakeup.delete();
      return PostListType();
    }
    final getWakeupImg = await getWakeup.getDownloadURL();
    final wakeUpPostData = PostType(
      postImg: getWakeupImg,
      doing: null,
      postDateTime: getWakeupDataString,
    );
    final getPostList = await storage.ref("users/$id/posts").listAll();
    final List<Future<void>> futures = [];
    for (final item in getPostList.items) {
      futures.add(() async {
        final split = item.name.split("@");
        if (split.length != 2) return;
        final postDateTime = DateTime.parse(split.first);
        if (!isWithinPostTimeRange(postDateTime) ||
            !isAfterThreeAM(postDateTime)) {
          await item.delete();
          return;
        }
        final getImg = await item.getDownloadURL();
        dataList.add(
          PostType(
            postImg: getImg,
            doing: split[1],
            postDateTime: postDateTime,
          ),
        );
      }());
    }
    await Future.wait(futures);
    final PostListType postList = PostListType(wakeUp: wakeUpPostData);
    postList.assignPostToTimeSlot(dataList);
    return postList;
  } catch (e) {
    return null;
  }
}
