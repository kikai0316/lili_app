import 'package:permission_handler/permission_handler.dart';

Future<bool> checkCameraPermission() async {
  final cameraStatus = await Permission.camera.status;
  if (cameraStatus.isGranted) {
    return true;
  } else if (cameraStatus.isDenied) {
    final requested = await Permission.camera.request();
    return requested.isGranted;
  } else if (cameraStatus.isPermanentlyDenied) {
    return false;
  } else {
    final requested = await Permission.camera.request();
    return requested.isGranted;
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
  } else if (status.isPermanentlyDenied) {
    return false;
  } else {
    status = await Permission.contacts.request();
    return status.isGranted;
  }
}
