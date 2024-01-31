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
