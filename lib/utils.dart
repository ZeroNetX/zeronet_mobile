import 'dart:ui';

import 'package:archive/archive.dart';
import 'imports.dart';

debugTime(Function func) {
  var start = DateTime.now();
  func();
  print(DateTime.now().difference(start).inMilliseconds);
}

printOut(Object object, {int lineBreaks = 0, bool isNative = false}) {
  if (kDebugMode || appVersion.contains('beta')) {
    var breaks = '';
    for (var i = 0; i < lineBreaks; i++) breaks = breaks + '\n';
    if (isNative)
      nativePrint(breaks + "$object" + breaks);
    else
      print(breaks + object + breaks);
  }
}

List<String> md5List = [];
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

initDownloadParams() async {
  await FlutterDownloader.initialize();
  bindDownloadIsolate();
  bindUnZipIsolate();
  FlutterDownloader.registerCallback(handleDownloads);
  packageInfo = await PackageInfo.fromPlatform();
  appVersion = packageInfo.version;
  buildNumber = packageInfo.buildNumber;
}

handleDownloads(String id, DownloadTaskStatus status, int progress) {
  final SendPort send = IsolateNameServer.lookupPortByName(isolateDownloadPort);
  send.send([id, status, progress]);
}

ReceivePort _downloadPort = ReceivePort();

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

void _unbindDownloadIsolate() {
  IsolateNameServer.removePortNameMapping(isolateDownloadPort);
}

ReceivePort _unZipPort = ReceivePort();
bool unZipIsolateBound = false;

bindUnZipIsolate() {
  bool isSuccess = IsolateNameServer.registerPortWithName(
      _unZipPort.sendPort, isolateUnZipPort);
  if (!isSuccess) {
    _unbindUnZipIsolate();
    bindUnZipIsolate();
    return;
  }
  unZipIsolateBound = true;
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
      printOut('Installation Completed', isNative: true);
      makeExecHelper();
      uninstallModules();
      check();
    }
  });
}

void _unbindUnZipIsolate() {
  IsolateNameServer.removePortNameMapping(isolateUnZipPort);
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

unZipinBg() async {
  if (arch != null)
    for (var item in files(arch)) {
      File f = File(tempDir.path + '/$item.zip');
      File f2 = File(installingMetaDir(tempDir.path, item, sesionKey));
      zeroNetState = state.INSTALLING;
      if (!(f2.existsSync())) {
        f2.createSync(recursive: true);
        if (f.path.contains('usr') || f.path.contains('tor')) {
          await compute(
            _unzipBytesAsync,
            UnzipParams(
              item,
              f.readAsBytesSync(),
              dest: 'usr/',
            ),
          );
        } else if (f.path.contains('site_packages') ||
            f.path.contains('lib-dynload')) {
          await compute(
            _unzipBytesAsync,
            UnzipParams(
              item,
              f.readAsBytesSync(),
              dest: 'usr/lib/python3.8/',
            ),
          );
        } else if (f.path.contains('python38')) {
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

int percentUnZip = 0;

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

makeExec(String path) => Process.runSync('chmod', ['744', path]);

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

Future<bool> isZeroNetInstalled() async {
  bool isExists = false;
  for (var item in files(arch)) {
    File f = File(installedMetaDir(metaDir.path, item));
    var exists = f.existsSync();
    if (!exists) return Future.value(exists);
    isExists = exists;
  }
  return isExists;
}

Future<bool> isZeroNetDownloaded() async {
  bool isExists = false;
  if (await isModuleInstallSupported()) {
    if (await isRequiredModulesInstalled()) {
      for (var item in files(arch)) {
        var i = files(arch).indexOf(item);
        bool f2 = File(tempDir.path + '/$item.zip').existsSync();
        if (i == files(arch).length - 1) {
          isExists = f2;
        } else if (!f2) {
          return false;
        }
      }
    }
  } else {
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
  }
  return isExists;
}

installPlugin(File file) async {
  await compute(
    _unzipBytesAsync,
    UnzipParams(
      'plugin',
      file.readAsBytesSync(),
      dest: 'ZeroNet-py3/plugins/',
    ),
  );
}

runTorEngine() {
  final tor = zeroNetNativeDir + '/libtor.so';
  if (File(tor).existsSync()) {
    printToConsole('Running Tor Engine..');
    Process.start('$tor', [], environment: {
      "LD_LIBRARY_PATH": "$libDir:$libDir64:/system/lib64",
    }).then((proc) {
      zero = proc;
      zero.stderr.listen((onData) {
        // printToConsole(utf8.decode(onData));
      });
      zero.stdout.listen((onData) {
        // printToConsole(utf8.decode(onData));
      });
    }).catchError((e) {
      if (e is ProcessException) {
        printOut(e.toString());
      }
    });
  } else
    //TODO: Improve Error Trace here
    printToConsole('Tor Binary Not Found');
}

runZeroNet() {
  if (varStore.zeroNetStatus == 'Not Running') {
    varStore.setZeroNetStatus('Initialising...');
    runTorEngine();
    log = '';
    printToConsole(logRunning);
    printToConsole(startZeroNetLog + '\n');
    var python = zeroNetNativeDir + '/libpython3.8.so';
    var openssl = zeroNetNativeDir + '/libopenssl.so';

    if (File(python).existsSync()) {
      var debug = (varStore.settings[debugZeroNet] as ToggleSetting).value;
      Process.start('$python', [
        zeronet,
        if (debug) '--debug',
        "--start_dir",
        zeroNetDir,
        "--openssl_bin_file",
        openssl
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
      //TODO: Improve Error Trace here
      printToConsole('Python Binary Not Found');
      var contents = Directory(zeroNetNativeDir).listSync(recursive: true);
      for (var item in contents) {
        printToConsole(item.name());
        printToConsole(item.path);
      }
    }
  } else {
    shutDownZeronet();
  }
}

shutDownZeronet() {
  if (varStore.zeroNetStatus == 'Running') {
    if (ZeroNet.isInitialised)
      ZeroNet.instance.shutDown();
    else {
      runZeroNetWs();
      try {
        ZeroNet.instance.shutDown();
      } catch (e) {
        printOut(e);
      }
    }
    zeroNetUrl = '';
    varStore.setZeroNetStatus('Not Running');
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

restartZeroNet() {
  ZeroNet.instance.shutDown();
  runZeroNet();
}

writeZeroNetConf(String str) {
  File f = File(zeroNetDir + '/zeronet.conf');
  if (f.existsSync()) {
    f.writeAsStringSync('\n' + str, mode: FileMode.append);
  } else {
    f.writeAsStringSync('[global]\n$str');
  }
}

//TODO : Move These ZeroNet Func to Seperate dart file.
bool isZeroNetUserDataExists() {
  return getZeroNetUsersFilePath().isNotEmpty;
}

String getZeroNetUsersFilePath() {
  var dataDir = getZeroNetDataDir();
  if (dataDir.existsSync()) {
    File f = File(dataDir.path + '/users.json');
    bool exists = f.existsSync();
    if (exists) {
      return f.path;
    }
    return zeroNetDir + '/data/users.json';
  } else {
    dataDir.createSync(recursive: true);
    File f = File(dataDir.path + '/users.json');
    f.createSync(recursive: true);
    return f.path;
  }
}

Directory getZeroNetDataDir() => Directory(
      ((varStore.settings[publicDataFolder] as ToggleSetting).value
              ? appPrivDir.path
              : zeroNetDir) +
          '/data',
    );

List<String> getZeroNameProfiles() {
  List<String> list = [];
  if (getZeroNetDataDir().existsSync())
    for (var item in getZeroNetDataDir().listSync()) {
      if (item is File) {
        if (item.path.endsWith('.json')) {
          var name = item.path.replaceAll(getZeroNetDataDir().path + '/', '');
          if (name.startsWith('users-')) {
            var username =
                name.replaceAll('users-', '').replaceAll('.json', '');
            list.add(username);
            printOut(username);
          }
        }
      }
    }
  return list;
}
