import 'package:permission_handler/permission_handler.dart';

Future<bool> checkCameraPermission() async {
  final status = await Permission.camera.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    return false;
  } else {
    final newStatus = await Permission.camera.request();
    return newStatus.isGranted;
  }
}

Future<bool> checkPhotoPermission() async {
  await Permission.photos.request();
  final status = await Permission.photos.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    return false;
  } else {
    final result = await Permission.photos.request();
    return result.isGranted;
  }
}

Future<bool> checkContactsPermission() async {
  PermissionStatus status = await Permission.contacts.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    status = await Permission.contacts.request();
    return status.isGranted;
  } else if (status.isPermanentlyDenied) {
    return false;
  } else {
    status = await Permission.contacts.request();
    return status.isGranted;
  }
}
