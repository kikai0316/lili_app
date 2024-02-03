import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lili_app/model/model.dart';

final firestore = FirebaseFirestore.instance.collection('users');
Future<bool?> dbFirestoreSearchUserId(String searchString) async {
  try {
    bool? isSearch;
    await firestore
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
  final DocumentReference docRef = firestore.doc(
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
  final DocumentReference docRef = firestore.doc(userData.openId);
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
  final DocumentReference docRef = firestore.doc(
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

Future<List<OnContactListType>> dbFirestoreSearchContacts(
  List<OnContactListType> contactsInfo,
) async {
  final results = await Future.wait(
    contactsInfo.map((value) async {
      final QuerySnapshot querySnapshot = await firestore
          .where(
            'phone_number',
            isEqualTo: value.phoneNumber.replaceAll(RegExp('[^0-9]'), ''),
          )
          .get();
      return querySnapshot.docs
          .map((doc) {
            final snapshotData = doc.data() as Map<String, dynamic>?;
            if (snapshotData == null) return null;
            return OnContactListType(
              phoneNumber: value.phoneNumber,
              userData: UserType.fromJson(snapshotData, doc.id),
            );
          })
          .where((userType) => userType != null)
          .cast<OnContactListType>();
    }),
  );
  return results.expand((userTypes) => userTypes).toList();
}

Future<List<UserType>> dbFirestoreSearchUser(String searchWord) async {
  final results = await Future.wait([
    firestore
        .where(
          'phone_number',
          isEqualTo: searchWord,
        )
        .get(),
    firestore.where('user_id', isEqualTo: searchWord).get(),
  ]);
  final users = results
      .expand((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          final snapshotData = doc.data();
          return UserType.fromJson(snapshotData, doc.id);
        });
      })
      .toSet()
      .toList();
  return users;
}

Future<bool> dbFirestoreFriendRequest(
  String friendOpneId,
  String myOpneID,
) async {
  try {
    final collectionRef = FirebaseFirestore.instance.collection('users');
    final docRef = collectionRef.doc(friendOpneId);
    await docRef.update(
      {
        "friend_request": FieldValue.arrayUnion([myOpneID]),
      },
    );
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> dbFirestoreFriendRequestPermission(
  String friendOpneId,
  String myOpneID,
) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final WriteBatch batch = firestore.batch();
  try {
    final DocumentReference friendDocRef =
        firestore.collection('users').doc(friendOpneId);
    final DocumentReference myDocRef =
        firestore.collection('users').doc(myOpneID);
    batch.update(friendDocRef, {
      "friend": FieldValue.arrayUnion([myOpneID]),
      "friend_request": FieldValue.arrayRemove([myOpneID]),
    });
    batch.update(myDocRef, {
      "friend": FieldValue.arrayUnion([friendOpneId]),
      "friend_request": FieldValue.arrayRemove([friendOpneId]),
    });
    await batch.commit();
    return true;
  } catch (e) {
    return false;
  }
}

Future<List<UserType>> dbFirestoreGetUsers(List<String> userIds) async {
  final futures = userIds.map((id) async {
    try {
      final DocumentSnapshot documentSnapshot = await firestore.doc(id).get();
      final Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        return UserType.fromJson(data, id);
      }
    } catch (e) {
      return null;
    }
    return null;
  });
  final List<UserType?> results = await Future.wait(futures);
  return results.where((user) => user != null).cast<UserType>().toList();
}
