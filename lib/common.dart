import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:random_string/random_string.dart';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mobx/varstore.dart';

Directory tempDir = Directory(dataDir + '/tmp');
Directory metaDir = Directory(dataDir + '/meta');
AndroidDeviceInfo deviceInfo;
bool isZeroNetInstalledm = false;
bool isZeroNetDownloadedm = false;
bool isDownloadExec = false;
bool _canLaunchUrl = false;
int downloadStatus = 0;
Map downloadsMap = {};
Map downloadStatusMap = {};
var dataDir = "/data/data/in.canews.zeronet/files";
var zeroNetState = state.NONE;
Client client = Client();
String arch;
String gitRepo = 'https://github.com/canewsin/ZeroNet';
String releases = gitRepo + '/releases/download/';
String zeroNetUrl = '';
String defZeroNetUrl = 'http://127.0.0.1:43110/';
String downloading = 'Downloading Files';
String installing = 'Installing ZeroNet';
String sesionKey = '';

List<Color> colors = [
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
List<String> binDirs = [
  'usr',
  'site-packages',
  'ZeroNet-py3',
];
List<String> soDirs = [
  'usr/bin',
  'usr/lib',
  'usr/lib/python3.8/lib-dynload',
];

List<String> md5List = [
  '30865832830c3bb1d67aeb48b0572774',
  '4908d51ff8f2daa35a209db0c86dc535',
  '3df0aae9c0f30941a3893f02b0533d65',
  'e09fab4484cf10d5bc29901f5c17df78',
  '11af969820fdc72db9d9c41abd98e4c9',
  '336b451616f620743e6aecb30900b822',
  '98c9109d618094a9775866c1838d4666',
  '11e86b9a2aae72f854bf1f181946d78b',
  '28d0faceb156ad1e5f1befa770dce3cd',
  '3a502a40f060bd57a2072161a8461390',
];

String downloadLink(String item) => releases + 'Android_Binaries/$item.zip';
bool isUsrBinExists() => Directory(dataDir + '/usr').existsSync();
bool isZeroNetExists() => Directory(dataDir + '/ZeroNet-py3').existsSync();
String downloadingMetaDir(String tempDir, String name, String key) =>
    Directory(tempDir + '/meta/$name.$key.downloading').path;
String downloadedMetaDir(String tempDir, String name) =>
    Directory(tempDir + '/meta/$name.downloaded').path;
String installingMetaDir(String tempDir, String name, String key) =>
    Directory(tempDir + '/meta/$name.$key.installing').path;
String installedMetaDir(String tempDir, String name) =>
    Directory(tempDir + '/meta/$name.installed').path;
Duration secs(int sec) => Duration(seconds: sec);
List<String> files(String arch) => [
      'usr-$arch',
      'site-packages-$arch',
      'site-packages-common',
      'ZeroNet-py3',
    ];

debugTime(Function func) {
  var start = DateTime.now();
  func();
  print(DateTime.now().difference(start).inMilliseconds);
}

makeExecHelper() {
  for (var item in soDirs) {
    var dir = Directory(dataDir + '/$item');
    if (dir.existsSync())
      for (var item in dir.listSync()) {
        if (item is File) {
          makeExec(item.path);
        }
      }
  }
}

init() async {
  sesionKey = randomAlpha(10);
  if (!tempDir.existsSync()) tempDir.createSync(recursive: true);
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

check() async {
  if (!isZeroNetInstalledm) {
    if (isZeroNetDownloadedm) {
      if (isZeroNetInstalledm) {
        varStore.setLoadingStatus('ZeroNet Installed');
        varStore.isZeroNetInstalled(isZeroNetInstalledm);
        printOut('isZeroNetInstalledm');
      } else {
        varStore.setLoadingStatus(installing);
        isZeroNetInstalled().then((onValue) async {
          isZeroNetInstalledm = onValue;
          varStore.isZeroNetInstalled(onValue);
          if (!isZeroNetInstalledm) {
            await unZipinBg();
          }
        });
      }
    } else {
      isZeroNetInstalledm = await isZeroNetInstalled();
      if (!isZeroNetInstalledm) {
        isZeroNetDownloadedm = await isZeroNetDownloaded();
        varStore.setLoadingStatus(downloading);
        if (!isDownloadExec) {
          downloadBins();
        } else {
          Timer(secs(2), () {
            isZeroNetDownloadedm = allFilesDownloaded();
            check();
          });
        }
      } else {
        varStore.isZeroNetInstalled(true);
      }
    }
  }
}

downloadBins() async {
  isDownloadExec = true;
  if (tempDir != null && arch != null) {
    int t = 0;
    for (var item in files(arch)) {
      t = t + 2;
      var file = File(tempDir.path + '/$item.zip');
      if (!file.existsSync()) {
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
        check();
      }
    }
    Timer(secs(5), () {
      check();
    });
  }
}

printOut(Object object) {
  print(object);
}

handleDownloads(String str, DownloadTaskStatus status, int percent) {
  if (percent == 100) {
    printOut("$str   $status   $percent");
    downloadStatus = downloadStatus + percent;
    printOut(downloadStatus);
    varStore.setLoadingPercent(downloadStatus ~/ 4);
    downloadStatusMap[str] = percent;
    for (var item in downloadsMap.keys) {
      if (downloadsMap[item] == str) {
        File(downloadedMetaDir(tempDir.path, item)).createSync(recursive: true);
      }
    }
    if (allFilesDownloaded()) {
      isZeroNetDownloadedm = true;
      varStore.isZeroNetDownloaded(true);
      check();
    }
  }
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
  varStore.isZeroNetInstalled(isExists);
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
  downloadStatus = 0;
  if (arch != null)
    for (var item in files(arch)) {
      int i = files(arch).indexOf(item);
      varStore.setLoadingPercent(25 * i);
      downloadStatus = downloadStatus + 100;
      File f = File(tempDir.path + '/$item.zip');
      File f2 = File(installingMetaDir(tempDir.path, item, sesionKey));
      // File f3 = File(tempDir.path + '/$item.installed');
      zeroNetState = state.INSTALLING;
      if (!(f2.existsSync())) {
        //&& f3.existsSync()
        f2.createSync(recursive: true);
        if (f.path.contains('usr')) {
          await compute(
            _unzipBytesAsync,
            UnzipParams(item, f.readAsBytesSync(), dest: 'usr/'),
          );
          makeExecHelper();
        } else if (f.path.contains('site-packages')) {
          await compute(
            _unzipBytesAsync,
            UnzipParams(
              item,
              f.readAsBytesSync(),
              dest: 'usr/lib/python3.8/',
            ),
          );
          makeExecHelper();
        } else {
          await compute(
            _unzipBytesAsync,
            UnzipParams(
              item,
              f.readAsBytesSync(),
            ),
          );
          makeExecHelper();
        }
      }
    }
  // printOut('Dont Call this Function Twice');
  check();
}

void _unzipBytesAsync(UnzipParams params) async {
  printOut("UnZippingFiles.......");
  var out = dataDir + '/' + params.dest;
  Archive archive = ZipDecoder().decodeBytes(params.bytes);
  for (ArchiveFile file in archive) {
    String filename = file.name;
    printOut('$out$filename');
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

List<Widget> zeroNetSites() {
  List<Widget> zeroSites = [];
  for (var key in Utils.initialSites.keys) {
    var name = key;
    var description = Utils.initialSites[key]['description'];
    var url = Utils.initialSites[key]['url'];
    var i = Utils.initialSites.keys.toList().indexOf(key);
    zeroSites.add(
      Container(
        height: 185,
        width: 185,
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors[i],
              colors[i + 1],
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      left: 15.0,
                    ),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                    ),
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                  right: 12.0,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: OutlineButton(
                    borderSide: BorderSide(color: Colors.white),
                    child: Text(
                      'Open',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_canLaunchUrl) {
                        launch(zeroNetUrl + url);
                      } else {
                        testUrl();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  return zeroSites;
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
      _canLaunchUrl = onValue;
    });
  }
}

class Utils {
  static const initialSites = {
    'ZeroHello': {
      'description': 'Hello Zeronet Site',
      'url': '1HeLLo4uzjaLetFx6NH3PMwFP3qbRbTf3D',
    },
    'ZeroTalk': {
      'description': 'Reddit-like, decentralized forum',
      'url': 'Talk.ZeroNetwork.bit',
    },
    'ZeroBlog': {
      'description': 'Microblogging Platform',
      'url': 'Blog.ZeroNetwork.bit',
    },
    'ZeroMail': {
      'description': 'End-to-End Encrypted Mailing',
      'url': 'Mail.ZeroNetwork.bit',
    },
    'ZeroMe': {
      'description': 'P2P Social Network',
      'url': 'Me.ZeroNetwork.bit',
    },
    'ZeroSites': {
      'description': 'Discover More Sites',
      'url': 'Sites.ZeroNetwork.bit',
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
