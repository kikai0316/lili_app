import 'dart:async';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/path_provider_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'all_past_post.g.dart';

@Riverpod(keepAlive: true)
class AllPastPostNotifier extends _$AllPastPostNotifier {
  @override
  Future<Map<String, PastPostListType>> build() async {
    return await localReadPastPostData() ?? {};
  }
}
