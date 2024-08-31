import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceDetails extends StatefulWidget {
  const DeviceDetails({super.key});

  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, String> _deviceData = <String, String>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Map<String, String> deviceData = <String, String>{};

    try {
      if (kIsWeb) {
        deviceData = _extractDeviceInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        deviceData = switch (defaultTargetPlatform) {
          TargetPlatform.android =>
              _extractDeviceInfo(await deviceInfoPlugin.androidInfo),
          TargetPlatform.iOS =>
              _extractDeviceInfo(await deviceInfoPlugin.iosInfo),
          TargetPlatform.linux =>
              _extractDeviceInfo(await deviceInfoPlugin.linuxInfo),
          TargetPlatform.windows =>
              _extractDeviceInfo(await deviceInfoPlugin.windowsInfo),
          TargetPlatform.macOS =>
              _extractDeviceInfo(await deviceInfoPlugin.macOsInfo),
          TargetPlatform.fuchsia => <String, String>{
            'Error': 'Fuchsia platform isn\'t supported'
          },
        };
      }
    } on PlatformException {
      deviceData = <String, String>{'Error': 'Failed to get platform version.'};
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, String> _extractDeviceInfo(dynamic deviceInfo) {
    if (deviceInfo is AndroidDeviceInfo) {
      return {
        'Model': deviceInfo.model,
        'Manufacturer': deviceInfo.manufacturer,
        'Brand': deviceInfo.brand,
        'SDK': deviceInfo.version.sdkInt.toString(),
        'Release': deviceInfo.version.release,
      };
    } else if (deviceInfo is IosDeviceInfo) {
      return {
        'Model': deviceInfo.model,
        'Manufacturer': 'Apple',
        'Brand': 'Apple',
        'SDK': deviceInfo.systemVersion,
        'Release': deviceInfo.systemVersion,
      };
    } else if (deviceInfo is WebBrowserInfo) {
      return {
        'Model': deviceInfo.browserName.name,
        'Manufacturer': 'Unknown',
        'Brand': 'Unknown',
        'SDK': deviceInfo.appVersion ?? 'Unknown',
        'Release': deviceInfo.appVersion ?? 'Unknown',
      };
    } else if (deviceInfo is MacOsDeviceInfo) {
      return {
        'Model': deviceInfo.model,
        'Manufacturer': 'Apple',
        'Brand': 'Apple',
        'SDK':
        '${deviceInfo.majorVersion}.${deviceInfo.minorVersion}.${deviceInfo.patchVersion}',
        'Release': deviceInfo.osRelease,
      };
    }
    return <String, String>{};
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_getAppBarTitle()),
          elevation: 4,
        ),
        body: ListView(
          children: _deviceData.keys.map(
                (String property) {
              return Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      property,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '${_deviceData[property]}',
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  String _getAppBarTitle() => kIsWeb
      ? 'Web Browser Info'
      : switch (defaultTargetPlatform) {
    TargetPlatform.android => 'Android Device Info',
    TargetPlatform.iOS => 'iOS Device Info',
    TargetPlatform.linux => 'Linux Device Info',
    TargetPlatform.windows => 'Windows Device Info',
    TargetPlatform.macOS => 'MacOS Device Info',
    TargetPlatform.fuchsia => 'Fuchsia Device Info',
  };
}
