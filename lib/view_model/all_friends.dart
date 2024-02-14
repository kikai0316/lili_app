import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/utility/firebase/firebase_storage_utility.dart';
import 'package:lili_app/utility/type_updata_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_friends.g.dart';

@Riverpod(keepAlive: true)
class AllFriendsNotifier extends _$AllFriendsNotifier {
  @override
  Future<List<UserType>> build() async {
    return [];
  }

  Future<void> reFetch(List<String> ids) async {
    final stateIds = state.value!.map((e) => e.openId).toList();
    final notIds = ids.where((e) => !stateIds.contains(e)).toList();
    final notIdsFutures = notIds.map((id) async {
      final profileData = await dbFirestoreReadUser(id);
      if (profileData == null) return null;
      final postData =
          await dbStoragePostDownload(id: profileData.openId) ?? PostListType();
      return userTypeUpDate(profileData, postListType: postData);
    }).toList();
    final notUsers =
        (await Future.wait(notIdsFutures)).whereType<UserType>().toList();

    final futures = state.value!.map((userData) async {
      final postData =
          await dbStoragePostDownload(id: userData.openId) ?? PostListType();
      return userTypeUpDate(userData, postListType: postData);
    }).toList();
    final users = (await Future.wait(futures)).whereType<UserType>().toList();
    state = await AsyncValue.guard(() async => [...users, ...notUsers]);
  }
}
