import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../mobx/varstore.dart';
import 'common.dart';
import 'constants.dart';
import 'utils.dart';

const MethodChannel _channel = const MethodChannel('in.canews.zeronet');
const EventChannel _events_channel =
    const EventChannel('in.canews.zeronet/installModules');

Future<bool> askBatteryOptimisation() async =>
    await _channel.invokeMethod('batteryOptimisations');

Future<bool> isPlayStoreInstall() async =>
    await _channel.invokeMethod('isPlayStoreInstall');

Future<bool> isBatteryOptimised() async =>
    await _channel.invokeMethod('isBatteryOptimized');

Future<String> saveUserJsonFile(String path) async =>
    await _channel.invokeMethod('saveUserJsonFile', path);

Future<bool> moveTaskToBack() async =>
    await _channel.invokeMethod('moveTaskToBack');

Future<bool> isModuleInstallSupported() async =>
    await _channel.invokeMethod('isModuleInstallSupported');

Future<bool> isRequiredModulesInstalled() async =>
    await _channel.invokeMethod('isRequiredModulesInstalled');

Future<bool> copyAssetsToCache() async =>
    await _channel.invokeMethod('copyAssetsToCache');

Future<bool> initSplitInstall() async =>
    await _channel.invokeMethod('initSplitInstall');

void uninstallModules() async =>
    await _channel.invokeMethod('uninstallModules');

void nativePrint(String log) => _channel.invokeMethod('nativePrint', log);

getNativeDir() async => await _channel.invokeMethod('nativeDir');

void handleModuleDownloadStatus() {
  _events_channel.receiveBroadcastStream().listen((onData) {
    Map data = json.decode(onData);
    final status = data['status'];
    if (status == 2) {
      final downloaded = data['downloaded'];
      final total = data['total'];
      double percentage = downloaded / total;
      varStore.setLoadingPercent(percentage.toInt());
    }
    printOut(onData, lineBreaks: 2, isNative: true);
    if (status == 5) check();
  });
}

String filePath = '';
Future<File> getUserJsonFile() async {
  String uri;
  if (deviceInfo.version.sdkInt > 28) {
    uri = await _channel.invokeMethod('openJsonFile');
    filePath = await FlutterAbsolutePath.getAbsolutePath(uri);
  } else {
    uri = (await pickUserJsonFile()).path;
    filePath = uri;
  }
  String path = await _channel.invokeMethod('readJsonFromUri', uri);
  return File(path);
}

Future<File> getPluginZipFile() async {
  String uri;
  if (deviceInfo.version.sdkInt > 28) {
    try {
      uri = await _channel.invokeMethod('openZipFile');
      filePath = await FlutterAbsolutePath.getAbsolutePath(uri);
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == '527') {
          return null;
        }
      }
    }
  } else {
    uri = (await pickPluginZipFile()).path;
    filePath = uri;
  }
  String path = await _channel.invokeMethod('readZipFromUri', uri);
  return File(path);
}

getArch() async {
  if (deviceInfo == null) deviceInfo = await DeviceInfoPlugin().androidInfo;
  String archL = deviceInfo.supportedAbis[0];
  if (archL.contains('arm64'))
    arch = 'arm64';
  else if (archL.contains('armeabi'))
    arch = 'arm';
  else if (archL.contains('x86_64'))
    arch = 'x86_64';
  else if (archL.contains('x86')) arch = 'x86';
}

initNotifications() {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final initializationSettingsIOS = IOSInitializationSettings();
  final initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  // final categories = [
  //   NotificationCategory(
  //     notificationCategory,
  //     [
  //       NotificationAction("Stop", "ACTION_CLOSE"),
  //       NotificationAction("Exit App", "ACTION_CLOSEAPP"),
  //     ],
  //   ),
  // ];
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: onSelectNotification,
    // onSelectNotificationAction: onSelectNotificationAction,
    // categories: categories,
  );
}

Future<void> onSelectNotification(String payload) async {
  if (payload != null) {
    printOut('notification payload: ' + payload);
  }
}

// Future<void> onSelectNotificationAction(NotificationActionData data) async {
//   printOut('notification action data: $data');
//   if (data.actionIdentifier == "ACTION_CLOSE") {
//     shutDownZeronet();
//   } else {
//     shutDownZeronet();
//     exit(0);
//   }
// }

Future<void> showZeroNetRunningNotification({
  bool enableVibration = true,
}) async {
  var androidDetails = AndroidNotificationDetails(
    zeroNetNotiId,
    zeroNetChannelName,
    zeroNetChannelDes,
    ongoing: true,
    playSound: false,
    autoCancel: false,
    enableVibration: enableVibration,
  );
  var iosDetails = IOSNotificationDetails();
  var details = NotificationDetails(
    androidDetails,
    iosDetails,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'ZeroNet Mobile is Running',
    'Click on Stop, to Stop ZeroNet or Click Here to Open App',
    details,
    // categoryIdentifier: notificationCategory,
    // payload: 'zeronet',
  );
}
