import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lili_app/model/model.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<bool?> dbFirestoreSearchUserId(String searchString) async {
  try {
    bool? isSearch;
    await firestore
        .collection('users')
        .where('user_id', isEqualTo: searchString)
        .get()
        .then((QuerySnapshot querySnapshot) {
      isSearch = querySnapshot.docs.isNotEmpty;
    });

    return isSearch;
  } catch (e) {
    return null;
  }
}

Future<UserType?> dbFirestoreLogin(UserType userData) async {
  final DocumentReference docRef = firestore.collection("users").doc(
        userData.openId,
      );
  try {
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      final snapshotData = docSnapshot.data() as Map<String, dynamic>?;
      if (snapshotData != null) {
        return UserType.fromJson(snapshotData, docSnapshot.id);
      } else {
        final writeUser = await dbFirestoreWriteUser(userData);
        return writeUser;
      }
    } else {
      final writeUser = await dbFirestoreWriteUser(userData);
      return writeUser;
    }
  } catch (e) {
    return null;
  }
}

Future<UserType?> dbFirestoreWriteUser(UserType userData) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DocumentReference docRef =
      firestore.collection("users").doc(userData.openId);
  try {
    final Map<String, dynamic> newData = {
      if (userData.img != null) "user_img": userData.img,
      "user_name": userData.name,
      "user_id": userData.userId,
      "phone_number": userData.phoneNumber,
      if (userData.toDayMood != null) "today_mood": userData.toDayMood,
      if (userData.comment != null) "user_comment": userData.comment,
      if (userData.birthday != null) "birthday": userData.birthday,
      "friend": [],
      "friend_request": [],
    };
    await docRef.set(newData);
    return userData;
  } catch (e) {
    return null;
  }
}

Future<UserType?> dbFirestoreReadUser(String openId) async {
  final DocumentReference docRef = firestore.collection("users").doc(
        openId,
      );
  try {
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      final snapshotData = docSnapshot.data() as Map<String, dynamic>?;
      if (snapshotData == null) return null;
      return UserType.fromJson(snapshotData, docSnapshot.id);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
