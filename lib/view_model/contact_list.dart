import 'package:contacts_service/contacts_service.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/utility/permission_utlity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contact_list.g.dart';

@Riverpod(keepAlive: true)
class ContactListNotifier extends _$ContactListNotifier {
  @override
  Future<ContactListType?> build() async {
    return await getContactList();
  }

  Future<void> reacquisition() async {
    state = const AsyncValue.loading();
    final getData = await getContactList();
    state = await AsyncValue.guard(() async {
      return getData;
    });
  }
}

Future<ContactListType?> getContactList() async {
  try {
    final isPermission = await checkContactsPermission();
    if (!isPermission) return null;
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    final List<OnContactListType> contactsInfo =
        contacts.where((contact) => contact.phones!.isNotEmpty).map((contact) {
      final String phoneNumber =
          contact.phones!.first.value ?? "No Phone Number";
      return OnContactListType(
        contactsImg: contact.avatar,
        contactsName: contact.displayName,
        phoneNumber: phoneNumber,
      );
    }).toList();
    final appUserList = await dbFirestoreSearchContacts(contactsInfo);
    final appUserListPhoneNumbers =
        appUserList.map((e) => e.phoneNumber).toList();
    final contactUserList = contactsInfo
        .where((e) => !appUserListPhoneNumbers.contains(e.phoneNumber))
        .toList();
    return ContactListType(
      appUserList: appUserList,
      contactUserList: contactUserList,
    );
  } catch (_) {
    return null;
  }
}
