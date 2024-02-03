import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _localFile(String fileName) async {
  final path = await _localPath;
  return File('$path/$fileName');
}

Future<File> localWriteList(
  List<String> data,
) async {
  final file = await _localFile("applying");
  final jsonList = jsonEncode(data);
  return file.writeAsString(jsonList);
}

Future<List<String>> localReadList() async {
  try {
    final file = await _localFile("applying");
    final String jsonList = await file.readAsString();
    final List<String> mylist =
        List<String>.from(jsonDecode(jsonList) as Iterable<dynamic>);
    return mylist;
  } catch (e) {
    return [];
  }
}
