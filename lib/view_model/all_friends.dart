import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/utility/firebase/firebase_storage_utility.dart';
import 'package:lili_app/utility/type_updata_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_friends.g.dart';

@Riverpod(keepAlive: true)
class AllFriendsNotifier extends _$AllFriendsNotifier {
  @override
  Future<List<UserType>?> build() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return [];
  }

  Future<void> init(List<String> ids) async {
    final futures = ids.map((id) async {
      final profileData = await dbFirestoreReadUser(id);
      if (profileData == null) return null;
      final postData =
          await dbStoragePostDownload(id: profileData.openId) ?? PostListType();
      return userTypeUpDate(profileData, postListType: postData);
    }).toList();
    final users = (await Future.wait(futures)).whereType<UserType>().toList();
    state = await AsyncValue.guard(() async => users);
  }

  Future<void> upDate() async {
    final futures = state.value!.map((userData) async {
      final postData =
          await dbStoragePostDownload(id: userData.openId) ?? PostListType();
      return userTypeUpDate(userData, postListType: postData);
    }).toList();
    final users = (await Future.wait(futures)).whereType<UserType>().toList();
    state = await AsyncValue.guard(() async => users);
  }
}
