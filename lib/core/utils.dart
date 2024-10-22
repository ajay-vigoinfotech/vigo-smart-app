import 'dart:io';
import 'package:apple_product_name/apple_product_name.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      final info = await DeviceInfoPlugin().iosInfo;
      deviceDetails =
          '${info.utsname.productName}/Apple/${iosInfo.model}/${iosInfo.utsname.release}/${iosInfo.systemVersion}';
    } else {
      final androidInfo = await deviceInfo.androidInfo;
      deviceDetails =
          '${androidInfo.model}/${androidInfo.brand}/${androidInfo.device}/${androidInfo.version.sdkInt}/${androidInfo.version.release}/${androidInfo.isPhysicalDevice}';
    }
    return deviceDetails;
  }

  static getIpAddress() async {
    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        print(
            '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
        return addr.address;
      }
    }
  }

  // Method to get the unique ID
  static Future<String> getUniqueID() async {
    final deviceInfo = DeviceInfoPlugin();
    String uniqueID;

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      uniqueID = iosInfo.identifierForVendor ?? 'Unknown ID';
    } else {
      uniqueID = 'Unsupported platform';
    }
    return uniqueID;
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

  // Method to get the FCM token
  static Future<String?> getFCMToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    try {
      final token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');
      return token;
    } catch (e) {
      print('Error fetching FCM token: $e');
      return null;
    }
  }

  //method to get Current Date and Time
  static String formatDateTime(String apiDateTime) {
    DateTime dateTime = DateTime.parse(apiDateTime);
    DateFormat formatter = DateFormat('dd/MM/yyyy h:mm a');
    return formatter.format(dateTime);
  }

  // //method to get Punch In Current Date and Time
  // static String punchInFormatDateTime(String apiDateTime) {
  //   DateTime dateTime = DateTime.parse(apiDateTime);
  //   DateFormat formatter = DateFormat('dd/MM/yyyy h:mm a');
  //   return formatter.format(dateTime);
  // }

}

