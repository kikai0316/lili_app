import 'dart:async';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/utility/firebase/firebase_storage_utility.dart';
import 'package:lili_app/utility/type_updata_utility.dart';
import 'package:lili_app/view_model/all_friends.dart';
import 'package:lili_app/view_model/all_request_friends.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_data.g.dart';

@Riverpod(keepAlive: true)
class UserDataNotifier extends _$UserDataNotifier {
  @override
  Future<UserType?> build() async {
    final result = await LineSDK.instance.currentAccessToken;
    if (result != null) {
      final getProfile = await LineSDK.instance.getProfile();
      final profileData = await dbFirestoreReadUser(getProfile.userId);
      if (profileData == null) return null;
      final postData =
          await dbStoragePostDownload(id: profileData.openId) ?? PostListType();
      final allFriendsNotifier = ref.read(allFriendsNotifierProvider.notifier);
      final allRequestFriendsNotifier =
          ref.read(allRequestFriendsNotifierProvider.notifier);

      allFriendsNotifier.reFetch(profileData.friendList);
      allRequestFriendsNotifier.getUsers(profileData.friendRequestList);
      return userTypeUpDate(profileData, postListType: postData);
    }
    return null;
  }

  Future<void> userDataUpDate(UserType userData) async {
    state = await AsyncValue.guard(() async {
      return userData;
    });
  }

  Future<void> reacquisition() async {
    final oldData = state.value!;
    final profileData = await dbFirestoreReadUser(oldData.openId);
    if (profileData == null) return;
    final allRequestFriendsNotifier =
        ref.read(allRequestFriendsNotifierProvider.notifier);
    await allRequestFriendsNotifier.getUsers(profileData.friendRequestList);
    final allFriendsNotifier = ref.read(allFriendsNotifierProvider.notifier);
    allFriendsNotifier.reFetch(profileData.friendList);
    state = await AsyncValue.guard(() async {
      return userTypeUpDate(profileData, postListType: oldData.postList);
    });
  }
}
