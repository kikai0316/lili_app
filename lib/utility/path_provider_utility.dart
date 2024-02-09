import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/type_updata_utility.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> localFile(String fileName) async {
  final path = await _localPath;
  return File('$path/$fileName');
}

// Future<File> localWriteList(
//   List<String> data,
// ) async {
//   final file = await localFile("applying");
//   final jsonList = jsonEncode(data);
//   return file.writeAsString(jsonList);
// }

// Future<List<String>> localReadList() async {
//   try {
//     final file = await localFile("applying");
//     final String jsonList = await file.readAsString();
//     final List<String> mylist =
//         List<String>.from(jsonDecode(jsonList) as Iterable<dynamic>);
//     return mylist;
//   } catch (e) {
//     return [];
//   }
// }

Future<bool> localWritePastPostData(
  PostTimeType postTime,
  PastPostType postData,
) async {
  try {
    final file = await localFile("pastpost");
    Map<String, dynamic> jsonMapDecode;
    if (await file.exists()) {
      final String jsonString = await file.readAsString();
      jsonMapDecode = jsonDecode(jsonString) as Map<String, dynamic>? ?? {};
    } else {
      jsonMapDecode = {};
    }
    final date = DateFormat('yyyy/MM/dd').format(DateTime.now());
    final pastPostListData = pastPstListTypeUpDate(
      PastPostListType.fromMap(jsonMapDecode),
      postTime,
      postData,
    );
    jsonMapDecode[date] = pastPostListData.toMap();
    final String jsonStringEncode = jsonEncode(jsonMapDecode);
    await file.writeAsString(jsonStringEncode);
    return true;
  } catch (e) {
    return false;
  }
}

Future<Map<String, PastPostListType>?> localReadPastPostData() async {
  try {
    final file = await localFile("pastpost");
    final String jsonString = await file.readAsString();
    final Map<String, dynamic> jsonMapDecode =
        jsonDecode(jsonString) as Map<String, dynamic>? ?? {};
    final Map<String, PastPostListType> result = {};
    jsonMapDecode.forEach((key, value) {
      result[key] = PastPostListType.fromMap(value as Map<String, dynamic>);
    });
    return result;
  } catch (e) {
    return null;
  }
}
