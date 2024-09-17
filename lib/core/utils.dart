import 'dart:io';
import 'package:apple_product_name/apple_product_name.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
      deviceDetails = '${androidInfo.model}/${androidInfo.brand}/${androidInfo.device}/${androidInfo.version.sdkInt}/${androidInfo.version.release}/${androidInfo.isPhysicalDevice}';
    }
    return deviceDetails;
  }

  // Method to get the IP address
  static Future<String> getIpAddress() async {
    try {
      final connectivity = Connectivity();
      final connectivityResult = await connectivity.checkConnectivity();

      // Only proceed if there's Wi-Fi or mobile connectivity
      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {

        // Get network interfaces based on the platform
        for (var interface in await NetworkInterface.list(
          includeLoopback: false,
          type: InternetAddressType.any,
        )) {
          for (var addr in interface.addresses) {
            // Return IPv4 address
            if (addr.type == InternetAddressType.IPv4) {
              return addr.address;
            }
          }
        }
      }
      return 'IP not found';
    } catch (e) {
      return 'Failed to get IP address: $e';
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
      uniqueID = 'Unsupported platform.s';
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
}
