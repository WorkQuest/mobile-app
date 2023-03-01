import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<PermissionStatus> getStatusPermission(
          Permission permission) async =>
      await permission.status;

  static Future<bool> requestForIos(Permission permission) async {
    final status = await getStatusPermission(permission);
    print('status -> $status');
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      await permission.request();
      return false;
    }

    await openAppSettings();
    return false;
  }

  static Future<bool> requestForAndroid(Permission permission) async {
    final status = await getStatusPermission(permission);
    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied)
      await openAppSettings();
    else
      await permission.request();
    return false;
  }

  static Future<bool> listPermissionIsGranted(
      List<Permission> permissions) async {
    bool result = true;

    await Stream.fromIterable(permissions).asyncMap((perm) async {
      final status = await perm.status;
      if (!status.isGranted) result = false;
    }).toList();

    return result;
  }

  static Future<bool> permissionIsGranted(Permission permission, {bool isIOS = false}) async {
    final status = await getStatusPermission(permission);

    if (isIOS) {
      return status.isGranted || status.isLimited;
    }
    return status.isGranted;
  }
}
