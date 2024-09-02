import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Utils {
  // Method to get the current DateTime in the specified format
  static String getCurrentFormattedDateTime() {
    final DateTime now = DateTime.now();
    return DateFormat('dd MMM yy HH:mm').format(now);
  }

  // Method to get device details
  static Future<String> getDeviceDetails(BuildContext context) async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceDetails;

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceDetails =
      '${iosInfo.name}/Apple/${iosInfo.model}/${iosInfo.utsname.release}/${iosInfo.systemVersion}/${iosInfo.identifierForVendor}';
    } else {
      final androidInfo = await deviceInfo.androidInfo;
      deviceDetails =
      '${androidInfo.model}/${androidInfo.brand}/${androidInfo.device}/${androidInfo.version.sdkInt}/${androidInfo.version.release}/${androidInfo.isPhysicalDevice}';
    }

    return deviceDetails;
  }

  // Method to get the current battery level
  static Future<int> getBatteryLevel() async {
    final battery = Battery();
    return await battery.batteryLevel;
  }

  // Method to get the current app version
  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
