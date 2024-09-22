import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<String?> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? deviceId;

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id; // Unique ID on Android
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor; // Unique ID on iOS
  }

  return deviceId;
}
