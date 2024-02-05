import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:lili_app/model/model.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> localFile(String fileName) async {
  final path = await _localPath;
  return File('$path/$fileName');
}

Future<File> localWriteList(
  List<String> data,
) async {
  final file = await localFile("applying");
  final jsonList = jsonEncode(data);
  return file.writeAsString(jsonList);
}

Future<List<String>> localReadList() async {
  try {
    final file = await localFile("applying");
    final String jsonList = await file.readAsString();
    final List<String> mylist =
        List<String>.from(jsonDecode(jsonList) as Iterable<dynamic>);
    return mylist;
  } catch (e) {
    return [];
  }
}

Future<bool> localWritePostData(PostListType postListData) async {
  try {
    final file = await localFile("post");
    Map<String, dynamic> jsonMapDecode;
    if (await file.exists()) {
      final String jsonString = await file.readAsString();
      jsonMapDecode = jsonDecode(jsonString) as Map<String, dynamic>? ?? {};
    } else {
      jsonMapDecode = {};
    }
    final date = DateFormat('yyyy/MM/dd').format(DateTime.now());
    jsonMapDecode[date] = postListData.toMap();
    final String jsonStringEncode = jsonEncode(jsonMapDecode);
    await file.writeAsString(jsonStringEncode);
    return true;
  } catch (e) {
    return false;
  }
}

Future<Map<String, PostListType>?> localReadPostData() async {
  try {
    final file = await localFile("post");
    final String jsonString = await file.readAsString();
    final Map<String, dynamic> jsonMapDecode =
        jsonDecode(jsonString) as Map<String, dynamic>? ?? {};
    final Map<String, PostListType> result = {};
    jsonMapDecode.forEach((key, value) {
      result[key] = PostListType.fromMap(value as Map<String, dynamic>);
    });
    return result;
  } catch (e) {
    return null;
  }
}
