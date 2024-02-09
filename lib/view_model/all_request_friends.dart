import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_request_friends.g.dart';

@Riverpod(keepAlive: true)
class AllRequestFriendsNotifier extends _$AllRequestFriendsNotifier {
  @override
  Future<List<UserType>?> build() async {
    return null;
  }

  Future<void> getUsers(List<String> userIds) async {
    final List<UserType> oldList = state.value ?? [];
    final List<String> oldUserIds = oldList.map((e) => e.openId).toList();
    final addUserIds =
        userIds.where((element) => !oldUserIds.contains(element)).toList();
    final getUserData = await dbFirestoreGetUsers(addUserIds);
    state = await AsyncValue.guard(() async {
      return [...oldList, ...getUserData];
    });
  }

  Future<void> delete(String userId) async {
    final list = [...state.value!];
    final int index = list.indexWhere((element) => element.openId == userId);
    if (index == -1) return;
    list.removeAt(index);
    state = await AsyncValue.guard(() async {
      return list;
    });
  }
}
