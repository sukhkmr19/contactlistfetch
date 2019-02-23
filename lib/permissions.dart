import 'package:simple_permissions/simple_permissions.dart';

Future requestPermission(Permission permission) async {
  final res = await SimplePermissions.requestPermission(permission);
  print("permission request result is " + res.toString());
  return res;
}

Future<bool> checkPermission(Permission permission) async {
  bool res = await SimplePermissions.checkPermission(permission);
  print("permission is " + res.toString());
  return res;
}

Future getPermissionStatus(Permission permission) async {
  final res = await SimplePermissions.getPermissionStatus(permission);
  print("permission status is " + res.toString());
  return res;
}
