import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:random_string/random_string.dart';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zeronet_ws/zeronet_ws.dart';
import 'mobx/varstore.dart';
import 'package:path_provider/path_provider.dart';

const String dataDir = "/data/data/in.canews.zeronet/files";
const String zeroNetDir = dataDir + '/ZeroNet-py3';
const String bin = '$dataDir/usr/bin';
const String python = '$bin/python';
const String libDir = '$dataDir/usr/lib';
const String libDir64 = '$dataDir/usr/lib64';
const String zeronetDir = '$dataDir/ZeroNet-py3';
const String zeronet = '$zeronetDir/zeronet.py';
const String defZeroNetUrl = 'http://127.0.0.1:43110/';
const String downloading = 'Downloading Files';
const String installing = 'Installing ZeroNet Files';
const String githubLink = 'https://github.com';
const String rawGithubLink = 'https://raw.githubusercontent.com';
const String canewsInRepo = '/canewsin/ZeroNet';
const String releases = '$githubLink$canewsInRepo/releases/download/';
const String md5hashLink = '$rawGithubLink$canewsInRepo/py3-patches/md5.hashes';
const String zeroNetNotiId = 'zeroNetNetiId';
const String zeroNetChannelName = 'ZeroNet Mobile';
const String zeroNetChannelDes =
    'Shows ZeroNet Notification to Persist from closing.';
const String notificationCategory = 'ZERONET_RUNNING';
const String isolateUnZipPort = 'unzip_send_port';
const String isolateDownloadPort = 'downloader_send_port';
const MethodChannel _channel = const MethodChannel('in.canews.zeronet');

const List<Color> colors = [
  Colors.cyan,
  Colors.indigoAccent,
  Color(0xFF9F63BF),
  Color(0xFFE2556F),
  Color(0xFF358AC7),
  Color(0xFFA176B6),
  Color(0xFFC04848),
  Color(0xFF4A569D),
  Color(0xFFF39963),
  Color(0xFFF1417D),
  Color(0xFF1BB2D4),
  Color(0xFF7ECA26),
];
const List<String> binDirs = [
  'usr',
  'site-packages',
  'ZeroNet-py3',
];
const List<String> soDirs = [
  'usr/bin',
  'usr/lib',
  'usr/lib/python3.8/lib-dynload',
  'usr/lib/python3.8/site-packages',
];
List<String> md5List = [];

Directory appPrivDir;
Directory tempDir;
Directory metaDir = Directory(dataDir + '/meta');
AndroidDeviceInfo deviceInfo;
bool isZeroNetInstalledm = false;
bool isZeroNetDownloadedm = false;
bool isDownloadExec = false;
bool canLaunchUrl = false;
bool firstTime = false;
int downloadStatus = 0;
Map downloadsMap = {};
Map downloadStatusMap = {};
PackageInfo packageInfo;
String appVersion = '';
String buildNumber;
var zeroNetState = state.NONE;
Client client = Client();
String arch;
String zeroNetUrl = '';
String zeroNetNativeDir = '';
String zeroNetIPwithPort(String url) =>
    url.replaceAll('http:', '').replaceAll('/', '').replaceAll('s', '');
String sesionKey = '';
String browserUrl = 'https://google.com';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

String downloadLink(String item) => releases + 'Android_Binaries_New/$item.zip';
bool isUsrBinExists() => Directory(dataDir + '/usr').existsSync();
bool isZeroNetExists() => Directory(dataDir + '/ZeroNet-py3').existsSync();
String downloadingMetaDir(String tempDir, String name, String key) =>
    Directory(tempDir + '/meta/$name.$key.downloading').path;
String downloadedMetaDir(String tempDir, String name) =>
    Directory(tempDir + '/meta/$name.downloaded').path;
String installingMetaDir(String tempDir, String name, String key) =>
    Directory(tempDir + '/meta/$name.$key.installing').path;
String installedMetaDir(String dir, String name) =>
    Directory(dir + '/$name.installed').path;
Duration secs(int sec) => Duration(seconds: sec);
List<String> files(String arch) => [
      'python3.8-$arch',
      'site-packages-common',
      'site-packages-$arch',
      'ZeroNet-py3',
    ];

shutDownZeronet() {
  if (varStore.zeroNetStatus == 'Running') {
    if (ZeroNet.isInitialised)
      ZeroNet.instance.shutDown();
    else {
      runZeroNetWs();
      ZeroNet.instance.shutDown();
    }
    zeroNetUrl = '';
    varStore.setZeroNetStatus('Not Running');
    flutterLocalNotificationsPlugin.cancelAll();
  }
}

runZeroNetWs() {
  var zeroNetUrlL = zeroNetUrl.isNotEmpty ? zeroNetUrl : defZeroNetUrl;
  zeroNetUrl = zeroNetUrlL;
  if (varStore.zeroNetWrapperKey.isEmpty) {
    ZeroNet.instance
        .getWrapperKey(zeroNetUrl + Utils.initialSites['ZeroHello']['url'])
        .then((value) {
      if (value != null) {
        ZeroNet.wrapperKey = value;
        varStore.zeroNetWrapperKey = value;
        browserUrl = zeroNetUrl;
      }
    });
  } else {
    ZeroNet.wrapperKey = varStore.zeroNetWrapperKey;
    browserUrl = zeroNetUrl;
  }
}

debugTime(Function func) {
  var start = DateTime.now();
  func();
  print(DateTime.now().difference(start).inMilliseconds);
}

Future<bool> makeExecHelper() async {
  for (var item in soDirs) {
    var dir = Directory(dataDir + '/$item');
    if (dir.existsSync()) {
      var list = dir.listSync();
      for (var item in list) {
        if (item is File) {
          printOut(item.path);
          makeExec(item.path);
        }
      }
    }
  }
  return true;
}

init() async {
  getArch();
  zeroNetNativeDir = await getNativeDir();
  loadSettings();
  isZeroNetInstalledm = await isZeroNetInstalled();
  if (isZeroNetInstalledm) varStore.isZeroNetInstalled(isZeroNetInstalledm);
  initNotifications();
  tempDir = await getTemporaryDirectory();
  appPrivDir = await getExternalStorageDirectory();
  if (!tempDir.existsSync()) tempDir.createSync(recursive: true);
}

const String batteryOptimisation = 'Disable Battery Optimisations';
const String batteryOptimisationDes =
    'This will Helps to Run App even App is in Background for long time.';
const String publicDataFolder = 'Public DataFolder';
const String publicDataFolderDes =
    'This Will Make ZeroNet Data Folder Accessible via File Manager.';
const String autoStartZeroNet = 'AutoStart ZeroNet';
const String autoStartZeroNetDes =
    'This Will Make ZeroNet Auto Start on App Start, So you don\'t have to click Start Button Every Time on App Start.';
const String autoStartZeroNetonBoot = 'AutoStart ZeroNet on Boot';
const String autoStartZeroNetonBootDes =
    'This Will Make ZeroNet Auto Start on Device Boot.';

Map<String, Setting> defSettings = {
  batteryOptimisation: Setting(
    name: batteryOptimisation,
    description: batteryOptimisationDes,
    value: false,
  ),
  publicDataFolder: Setting(
    name: publicDataFolder,
    description: publicDataFolderDes,
    value: false,
  ),
  autoStartZeroNet: Setting(
    name: autoStartZeroNet,
    description: autoStartZeroNetDes,
    value: true,
  ),
  autoStartZeroNetonBoot: Setting(
    name: autoStartZeroNetonBoot,
    description: autoStartZeroNetonBootDes,
    value: false,
  ),
};

class Setting {
  String name;
  String description;
  bool value;

  Setting({
    this.name,
    this.description,
    this.value,
  });

  String toJson() => json.encode({
        'name': name,
        'description': description,
        'value': value,
      });

  Setting fromJson(Map<String, dynamic> map) {
    return Setting(
      name: map['name'],
      description: map['description'],
      value: map['value'],
    );
  }
}

Future<bool> askBatteryOptimisation() async =>
    await _channel.invokeMethod('batteryOptimisations');

Future<bool> isBatteryOptimised() async =>
    await _channel.invokeMethod('isBatteryOptimized');

loadSettings() {
  File f = File(dataDir + '/settings.json');
  List map;
  if (f.existsSync()) {
    map = json.decode(f.readAsStringSync());
  } else {
    firstTime = true;
    saveSettings(defSettings);
    map = json.decode(maptoStringList(defSettings));
  }
  for (var i = 0; i < map.length; i++) {
    varStore.updateSetting(Setting().fromJson(map[i]));
  }
  // if(varStore.settings[publicDataFolder].value){

  // }
}

saveSettings(Map map) {
  File f = File(dataDir + '/settings.json');
  f.writeAsStringSync(maptoStringList(map));
}

String maptoStringList(Map map) {
  String str = '';
  for (var key in map.keys) {
    int i = map.keys.toList().indexOf(key);
    if (i == map.keys.length - 1) {
      str = str + map[key].toJson();
    } else
      str = str + map[key].toJson() + ',';
  }
  str = '[$str]';
  return str;
}

String log = 'Click on Fab to Run ZeroNet\n';
String logRunning = 'Running ZeroNet\n';
String uiServerLog = 'Ui.UiServer';
String startZeroNetLog = 'Starting ZeroNet';
Process zero;

printToConsole(Object object) {
  if (object is String) {
    if (!object.contains(startZeroNetLog)) {
      if (appVersion.contains('beta')) print(object);
      if (object.contains(uiServerLog)) {
        // var s = object.replaceAll(uiServerLog, '');
        int httpI = object.indexOf('Web interface: http');
        // int columnI = object.indexOf(':');
        int end = object.indexOf('/\n');
        // int slashI = object.indexOf('/', columnI);
        if (zeroNetUrl.isEmpty && httpI != -1) {
          var _zeroNetUrl = (end == -1)
              ? object.substring(httpI + 15)
              : object.substring(httpI + 15, end + 1);
          if (zeroNetUrl != _zeroNetUrl) zeroNetUrl = _zeroNetUrl;
          testUrl();
        }
      }
      if (object.contains('Server port opened')) {
        runZeroNetWs();
        varStore.setZeroNetStatus('Running');
        showZeroNetRunningNotification();
      }
    }
  }
  log = log + object + '\n';
  varStore.setZeroNetLog(log);
}

runZeroNet() {
  if (varStore.zeroNetStatus == 'Not Running') {
    varStore.setZeroNetStatus('Initialising...');
    log = '';
    printToConsole(logRunning);
    printToConsole(startZeroNetLog + '\n');
    var python = zeroNetNativeDir + '/python3.8.so';
    Process.start('$python', [
      zeronet
    ], environment: {
      "LD_LIBRARY_PATH": "$libDir:$libDir64:/system/lib64",
      'PYTHONHOME': '$dataDir/usr',
      'PYTHONPATH': '$python',
    }).then((proc) {
      zero = proc;
      zero.stderr.listen((onData) {
        printToConsole(utf8.decode(onData));
      });
      zero.stdout.listen((onData) {
        printToConsole(utf8.decode(onData));
      });
    }).catchError((e) {
      if (e is ProcessException) {
        printOut(e.toString());
      }
      varStore.setZeroNetStatus('Not Running');
    });
  } else {
    shutDownZeronet();
  }
}

writeZeroNetConf(String str) {
  File f = File(zeroNetDir + '/zeronet.conf');
  if (f.existsSync()) {
    f.writeAsStringSync('\n' + str, mode: FileMode.append);
  } else {
    f.writeAsStringSync('[global]\n$str');
  }
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

getNativeDir() async =>
    await MethodChannel('in.canews.zeronet').invokeMethod('nativeDir');

initDownloadParams() async {
  await FlutterDownloader.initialize();
  bindDownloadIsolate();
  bindUnZipIsolate();
  FlutterDownloader.registerCallback(handleDownloads);
  packageInfo = await PackageInfo.fromPlatform();
  appVersion = packageInfo.version;
  buildNumber = packageInfo.buildNumber;
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

Future<void> showZeroNetRunningNotification(
    {bool enableVibration = true}) async {
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
  var details = NotificationDetails(androidDetails, iosDetails);
  await flutterLocalNotificationsPlugin.show(
    0,
    'ZeroNet Mobile is Running',
    'Click on Stop, to Stop ZeroNet or Click Here to Open App',
    details,
    // categoryIdentifier: notificationCategory,
    // payload: 'zeronet',
  );
}

int i = 0;
bool created = false;

check() async {
  if (!isZeroNetInstalledm) {
    if (isZeroNetDownloadedm) {
      if (isZeroNetInstalledm) {
        varStore.setLoadingStatus('ZeroNet Installed');
        varStore.isZeroNetInstalled(isZeroNetInstalledm);
        printOut('isZeroNetInstalledm');
      } else {
        isZeroNetInstalled().then((onValue) async {
          isZeroNetInstalledm = onValue;
          varStore.isZeroNetInstalled(onValue);
          if (!isZeroNetInstalledm) {
            unZipinBg();
          }
        });
      }
    } else {
      isZeroNetInstalledm = await isZeroNetInstalled();
      if (!isZeroNetInstalledm) {
        isZeroNetDownloadedm = await isZeroNetDownloaded();
        varStore.setLoadingStatus(downloading);
        if (!isDownloadExec) {
          await initDownloadParams();
          downloadBins();
        }
      } else {
        varStore.isZeroNetInstalled(true);
      }
    }
  }
}

ReceivePort _downloadPort = ReceivePort();
ReceivePort _unZipPort = ReceivePort();

void _unbindDownloadIsolate() {
  IsolateNameServer.removePortNameMapping(isolateDownloadPort);
}

void _unbindUnZipIsolate() {
  IsolateNameServer.removePortNameMapping(isolateUnZipPort);
}

bindDownloadIsolate() {
  bool isSuccess = IsolateNameServer.registerPortWithName(
      _downloadPort.sendPort, isolateDownloadPort);
  if (!isSuccess) {
    _unbindDownloadIsolate();
    bindDownloadIsolate();
    return;
  }
  _downloadPort.listen((data) {
    String id = data[0];
    DownloadTaskStatus status = data[1];
    int progress = data[2];
    for (var item in downloadsMap.keys) {
      if (downloadsMap[item] == id) {
        downloadStatusMap[id] = progress;
        if (status == DownloadTaskStatus.complete)
          File(downloadedMetaDir(tempDir.path, item))
              .createSync(recursive: true);
      }
    }
    var progressA = 0;
    for (var key in downloadStatusMap.keys) {
      progressA = (progressA + downloadStatusMap[key]);
    }
    var nooffiles = files(arch).length;
    varStore.setLoadingPercent(progressA ~/ nooffiles);
    if ((progressA ~/ nooffiles) == 100) {
      isZeroNetDownloadedm = true;
      varStore.setLoadingStatus(installing);
      varStore.setLoadingPercent(0);
      check();
    }
  });
}

int percentUnZip = 0;

bindUnZipIsolate() {
  bool isSuccess = IsolateNameServer.registerPortWithName(
      _unZipPort.sendPort, isolateUnZipPort);
  if (!isSuccess) {
    _unbindUnZipIsolate();
    bindUnZipIsolate();
    return;
  }
  _unZipPort.listen((data) {
    String name = data[0];
    int currentFile = data[1];
    int totalFiles = data[2];
    var percent = (currentFile / totalFiles) * 100;
    if (percent.toInt() % 5 == 0) {
      varStore.setLoadingStatus('Installing $name');
      varStore.setLoadingPercent(percent.toInt());
    }
    if (percent == 100) {
      percentUnZip = percentUnZip + 100;
    }
    var nooffiles = files(arch).length;
    if (percentUnZip == nooffiles * 100) {
      makeExecHelper();
      check();
    }
  });
}

downloadBins() async {
  isDownloadExec = true;
  if (tempDir != null && arch != null) {
    int t = 0;
    for (var item in files(arch)) {
      t = t + 2;
      var file = File(tempDir.path + '/$item.zip');
      if (!file.existsSync()) {
        sesionKey = randomAlpha(10);
        var tempFilePath = downloadingMetaDir(
          tempDir.path,
          item,
          sesionKey,
        );
        if (!File(tempFilePath).existsSync()) {
          Timer(Duration(seconds: t), () {
            FlutterDownloader.enqueue(
              url: downloadLink(item),
              savedDir: tempDir.path,
              showNotification: false,
              openFileFromNotification: false,
            ).then((taskId) {
              File(tempFilePath).createSync(recursive: true);
              downloadsMap[item] = taskId;
            });
          });
        }
      } else {
        var bytes = file.readAsBytesSync();
        var digest = md5.convert(bytes).toString();
        var res = await client.get(md5hashLink);
        var list = json.decode(res.body) as List;
        list.forEach((f) => md5List.add(f as String));
        for (var hash in md5List) {
          if (digest == hash) {
            File f = File(downloadedMetaDir(tempDir.path, item));
            if (!f.existsSync()) f.createSync(recursive: true);
            printOut(item + ' downloaded');
            if (files(arch).length - 1 == files(arch).indexOf(item)) {
              isZeroNetDownloadedm = true;
            }
          }
        }
      }
    }
    check();
  }
}

printOut(Object object) {
  if (kDebugMode || appVersion.contains('beta')) print(object);
}

handleDownloads(String id, DownloadTaskStatus status, int progress) {
  final SendPort send = IsolateNameServer.lookupPortByName(isolateDownloadPort);
  send.send([id, status, progress]);
}

load() async {
  if (arch == null) await init();
  isZeroNetInstalled().then((onValue) {
    isZeroNetInstalledm = onValue;
    if (!isZeroNetInstalledm)
      isZeroNetDownloaded().then((onValue) {
        isZeroNetDownloadedm = onValue;
      });
  });
}

unzip() async {
  downloadStatus = 0;
  for (var item in files(arch)) {
    downloadStatus = downloadStatus + 100;
    File f = File(tempDir.path + '/$item.zip');
    File f2 = File(tempDir.path + '/$item.installing');
    File f3 = File(tempDir.path + '/$item.installed');
    zeroNetState = state.INSTALLING;
    if (!(f2.existsSync() && f3.existsSync())) {
      if (f.path.contains('usr'))
        _unzipBytes(item, f.readAsBytesSync(), dest: 'usr/');
      else if (f.path.contains('site-packages'))
        _unzipBytes(item, f.readAsBytesSync(), dest: 'usr/lib/python3.8/');
      else
        _unzipBytes(item, f.readAsBytesSync());
      f2.createSync(recursive: true);
    }
  }
  isZeroNetInstalledm = await isZeroNetInstalled();
}

Future<bool> isZeroNetInstalled() async {
  bool isExists = false;
  for (var item in files(arch)) {
    var i = binDirs.indexOf(item);
    File f = File(installedMetaDir(metaDir.path, item));
    var exists = f.existsSync();
    if (!exists) return Future.value(exists);
    if (i == binDirs.length - 1) {
      isExists = exists;
    }
  }
  return isExists;
}

Future<bool> isZeroNetDownloaded() async {
  bool isExists = false;
  for (var item in files(arch)) {
    var i = binDirs.indexOf(item);
    bool f = File(downloadedMetaDir(tempDir.path, item)).existsSync();
    // bool f1 = File(tempDir.path + '/$item.downloading').existsSync();
    bool f2 = File(tempDir.path + '/$item.zip').existsSync();
    bool isAllDownloaded = allFilesDownloaded();
    var exists = ((f && f2) || isAllDownloaded);
    if (!exists) return Future.value(exists);
    if (i == binDirs.length - 1) {
      isExists = exists;
    }
  }
  varStore.isZeroNetDownloaded(isExists);
  return isExists;
}

bool allFilesDownloaded() {
  bool isDownloaded = false;
  for (var item in files(arch)) {
    bool isLast = files(arch).length - 1 == files(arch).indexOf(item);
    File file = File(downloadedMetaDir(tempDir.path, item));
    if (file.existsSync()) {
      if (isLast) isDownloaded = true;
    } else {
      File f = File(tempDir.path + '/$item.zip');
      if (f.existsSync()) {
        if (!isHashMatched(f)) return false;
        file.createSync(recursive: true);
        if (isLast) isDownloaded = isHashMatched(f);
      }
    }
  }
  return isDownloaded;
}

bool isHashMatched(File file) {
  var bytes = file.readAsBytesSync();
  var digest = md5.convert(bytes).toString();
  for (var hash in md5List) {
    if (digest == hash) {
      return true;
    }
  }
  return false;
}

unZipinBg() async {
  if (arch != null)
    for (var item in files(arch)) {
      File f = File(tempDir.path + '/$item.zip');
      File f2 = File(installingMetaDir(tempDir.path, item, sesionKey));
      zeroNetState = state.INSTALLING;
      if (!(f2.existsSync())) {
        f2.createSync(recursive: true);
        if (f.path.contains('usr')) {
          await compute(
            _unzipBytesAsync,
            UnzipParams(item, f.readAsBytesSync(), dest: 'usr/'),
          );
        } else if (f.path.contains('site-packages') ||
            f.path.contains('lib-dynload')) {
          await compute(
            _unzipBytesAsync,
            UnzipParams(
              item,
              f.readAsBytesSync(),
              dest: 'usr/lib/python3.8/',
            ),
          );
        } else if (f.path.contains('python3.8')) {
          await compute(
            _unzipBytesAsync,
            UnzipParams(
              item,
              f.readAsBytesSync(),
              dest: 'usr/lib/',
            ),
          );
        } else {
          await compute(
            _unzipBytesAsync,
            UnzipParams(
              item,
              f.readAsBytesSync(),
            ),
          );
        }
      }
    }
  // printOut('Dont Call this Function Twice');
  // check();
}

void _unzipBytesAsync(UnzipParams params) async {
  printOut("UnZippingFiles.......");
  var out = dataDir + '/' + params.dest;
  Archive archive = ZipDecoder().decodeBytes(params.bytes);
  int totalfiles = archive.length;
  int i = 0;
  for (ArchiveFile file in archive) {
    String filename = file.name;
    printOut('$out$filename');
    i++;
    final SendPort send = IsolateNameServer.lookupPortByName(isolateUnZipPort);
    send.send([params.item, i, totalfiles]);
    String outName = '$out' + filename;
    if (file.isFile) {
      List<int> data = file.content;
      // if (!File(outName).existsSync()) {
      File f = File(outName);
      if (!f.existsSync())
        f
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      // }
    } else {
      Directory(outName).exists().then((exists) {
        if (!exists) Directory(outName)..create(recursive: true);
      });
    }
  }
  File(installedMetaDir(metaDir.path, params.item)).createSync(recursive: true);
}

_unzipBytes(String name, List<int> bytes, {String dest = ''}) async {
  printOut("UnZippingFiles.......");
  var out = dataDir + '/' + dest;
  Archive archive = ZipDecoder().decodeBytes(bytes);
  for (ArchiveFile file in archive) {
    String filename = file.name;
    printOut('$out$filename');
    String outName = '$out' + filename;
    if (file.isFile) {
      List<int> data = file.content;
      // if (!File(outName).existsSync()) {
      File(outName).exists().then((onValue) {
        if (!onValue) {
          File(outName)
            ..createSync(recursive: true)
            ..writeAsBytes(data).then((f) {
              bool isBin = f.path.contains('bin');
              if (isBin)
                makeExec(f.path);
              else if (f.path.contains('.so')) makeExec(f.path);
            });
        }
      });
      // }
    } else {
      Directory(outName).exists().then((exists) {
        if (!exists) Directory(outName)..create(recursive: true);
      });
    }
  }
  File(installedMetaDir(tempDir.path, name)).createSync(recursive: true);
}

makeExec(String path) => Process.runSync('chmod', ['744', path]);

testUrl() {
  if (zeroNetUrl.isNotEmpty) {
    canLaunch(zeroNetUrl).then((onValue) {
      canLaunchUrl = onValue;
    });
  }
}

class Utils {
  static const String urlHello = '1HeLLo4uzjaLetFx6NH3PMwFP3qbRbTf3D';
  static const String urlTalk = 'Talk.ZeroNetwork.bit';
  static const String urlBlog = 'Blog.ZeroNetwork.bit';
  static const String urlMail = 'Mail.ZeroNetwork.bit';
  static const String urlMe = 'Me.ZeroNetwork.bit';
  static const String urlSites = 'Sites.ZeroNetwork.bit';

  static const initialSites = const {
    'ZeroHello': {
      'description': 'Hello Zeronet Site',
      'url': urlHello,
    },
    'ZeroTalk': {
      'description': 'Reddit-like, decentralized forum',
      'url': urlTalk,
    },
    'ZeroBlog': {
      'description': 'Microblogging Platform',
      'url': urlBlog,
    },
    'ZeroMail': {
      'description': 'End-to-End Encrypted Mailing',
      'url': urlMail,
    },
    'ZeroMe': {
      'description': 'P2P Social Network',
      'url': urlMe,
    },
    'ZeroSites': {
      'description': 'Discover More Sites',
      'url': urlSites,
    },
  };

  // 'ZeroName': '1Name2NXVi1RDPDgf5617UoW7xA6YrhM9F',
}

class UnzipParams {
  String item;
  Uint8List bytes;
  String dest;
  UnzipParams(
    this.item,
    this.bytes, {
    this.dest = '',
  });
}

enum state {
  NOT_DOWNLOADED,
  DOWNLOADING,
  NOT_INSTALLED,
  INSTALLING,
  MAKING_AS_EXEC,
  READY,
  RUNNING,
  NONE,
}
