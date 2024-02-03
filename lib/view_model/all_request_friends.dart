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
    final getUserData = await dbFirestoreGetUsers(userIds);
    state = await AsyncValue.guard(() async {
      return getUserData;
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
