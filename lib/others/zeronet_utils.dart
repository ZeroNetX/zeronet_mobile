import '../imports.dart';

Future checkInitStatus() async {
  loadSitesFromFileSystem();
  loadUsersFromFileSystem();
  setZeroBrowserThemeValues();
  try {
    String url = defZeroNetUrl + Utils.initialSites['ZeroNetMobile']['url'];
    String key = await ZeroNet.instance.getWrapperKey(url);
    zeroNetUrl = defZeroNetUrl;
    varStore.zeroNetWrapperKey = key;
    uiStore.setZeroNetStatus(ZeroNetStatus.RUNNING);
    ZeroNet.instance.connect(
      zeroNetIPwithPort(defZeroNetUrl),
      Utils.urlZeroNetMob,
    );
    service.sendData({'notification': 'ZeroNetStatus.RUNNING'});
    testUrl();
  } catch (e) {
    if (launchUrl.isNotEmpty ||
        ((varStore.settings[autoStartZeroNet] as ToggleSetting).value &&
                !firstTime) &&
            !manuallyStoppedZeroNet) {
      //TODO: Remember this!
      // service.sendData({'cmd': 'runZeroNet'});
    }
    if (e is OSError) {
      if (e.errorCode == 111) {
        printToConsole('Zeronet Not Running');
        uiStore.setZeroNetStatus(ZeroNetStatus.NOT_RUNNING);
      }
    }
  }
}

checkForAppUpdates() async {
  DateTime time = DateTime.now();
  var updateTimeEpoch = int.parse(await getAppLastUpdateTime());
  var updateTime = DateTime.fromMillisecondsSinceEpoch(updateTimeEpoch);
  int updateDays;
  if (appVersion.contains('internal')) {
    updateDays = time.difference(updateTime).inSeconds;
  } else {
    updateDays = time.difference(updateTime).inDays;
  }
  if (updateDays > 3 && !kDebugMode) {
    if (kIsPlayStoreInstall) {
      AppUpdateInfo info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailable && info.flexibleUpdateAllowed)
        uiStore.updateInAppUpdateAvailable(AppUpdate.AVAILABLE);
    }
  }
}

loadSitesFromFileSystem() {
  File sitesFile = File(getZeroNetDataDir().path + '/sites.json');
  if (sitesFile.existsSync())
    sitesAvailable = SiteManager().loadSitesFromFile(sitesFile);
}

loadUsersFromFileSystem() {
  File usersFile = File(getZeroNetDataDir().path + '/users.json');
  if (usersFile.existsSync())
    usersAvailable = UserManager().loadUsersFromFile(usersFile);
}

setZeroBrowserThemeValues() {
  if (usersAvailable.length > 0)
    zeroBrowserTheme = usersAvailable.first.settings.theme ?? 'light';
}

runTorEngine() {
  service = FlutterBackgroundService();
  final tor = zeroNetNativeDir + '/libtor.so';
  if (File(tor).existsSync()) {
    service.sendData({'console': 'Running Tor Engine..'});
    Process.start('$tor', [], environment: {
      "LD_LIBRARY_PATH": "$libDir:$libDir64:/system/lib64",
    }).then((proc) {
      zero = proc;
      zero.stderr.listen((onData) {
        // service.sendData({'console': utf8.decode(onData)});
      });
      zero.stdout.listen((onData) {
        // service.sendData({'console': utf8.decode(onData)});
      });
    }).catchError((e) {
      if (e is ProcessException) {
        printOut(e.toString());
      }
    });
  } else {
    //TODO: Improve Error Trace here
    service.sendData({'console': 'Tor Binary Not Found'});
    uiStore.setZeroNetStatus(ZeroNetStatus.RUNNING);
  }
}

runZeroNet() {
  if (uiStore.zeroNetStatus == ZeroNetStatus.NOT_RUNNING ||
      uiStore.zeroNetStatus == ZeroNetStatus.ERROR) {
    uiStore.setZeroNetStatus(ZeroNetStatus.INITIALISING);
    service.sendData({'ZeroNetStatus': 'INITIALISING'});
    runTorEngine();
    log = '';
    service.sendData({'console': logRunning});
    service.sendData({'console': startZeroNetLog + '\n'});
    var python = zeroNetNativeDir + '/libpython3.8.so';
    var openssl = zeroNetNativeDir + '/libopenssl.so';

    if (File(python).existsSync()) {
      Process.start('$python', [
        zeronet,
        if (debugZeroNetCode) '--debug',
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
          service.sendData({'console': utf8.decode(onData)});
        });
        zero.stdout.listen((onData) {
          service.sendData({'console': utf8.decode(onData)});
        });
      }).catchError((e) {
        if (e is ProcessException) {
          printOut(e.toString());
        }
        uiStore.setZeroNetStatus(ZeroNetStatus.ERROR);
        service.sendData({'ZeroNetStatus': 'ERROR'});
        service.sendData({'console': e.toString()});
      });
    } else {
      //TODO: Improve Error Trace here
      service.sendData({'console': 'Python Binary Not Found'});
      uiStore.setZeroNetStatus(ZeroNetStatus.ERROR);
      service.sendData({'ZeroNetStatus': 'ERROR'});
      service.sendData({'console': 'zeroNetNativeDir : $zeroNetNativeDir'});
      var contents = Directory(zeroNetNativeDir).listSync(recursive: true);
      for (var item in contents) {
        service.sendData({'console': item.name()});
        service.sendData({'console': item.path});
      }
    }
  } else {
    shutDownZeronet();
  }
}

void runBgIsolate() {
  WidgetsFlutterBinding.ensureInitialized();
  service = FlutterBackgroundService();
  service.onDataReceived.listen(onBgServiceDataReceivedForIsolate);
  service.sendData({'status': 'Started Background Service Successfully'});
  Timer(Duration(milliseconds: 500), () {
    if (zeroNetStartedFromBoot) {
      setBgServiceRunningNotification();
      if (zeroNetNativeDir.isEmpty || zeroNetNativeDir == null) {
        loadSettings();
        loadDataFile();
        debugZeroNetCode =
            (varStore.settings[debugZeroNet] as ToggleSetting).value;
        vibrateonZeroNetStart =
            (varStore.settings[vibrateOnZeroNetStart] as ToggleSetting).value;
        runZeroNet();
        setZeroNetRunningNotification();
      }
    }
  });
}

void onBgServiceDataReceivedForIsolate(Map<String, dynamic> data) {
  if (data.keys.first == 'cmd') {
    switch (data.values.first) {
      case 'runZeroNet':
        runZeroNet();
        break;
      case 'shutDownZeronet':
        //TODO: iMPLEMENT THIS.
        break;
      default:
    }
  } else if (data.keys.first == 'init') {
    Map initMap = data['init'];
    zeroNetNativeDir = initMap['zeroNetNativeDir'];
    debugZeroNetCode = initMap['debugZeroNetCode'];
    zeroNetStartedFromBoot = initMap['zeroNetStartedFromBoot'];
    vibrateonZeroNetStart = initMap['vibrateOnZeroNetStart'];
    setBgServiceRunningNotification();
  } else if (data.keys.first == 'notification') {
    if (data.values.first == 'ZeroNetStatus.RUNNING') {
      setZeroNetRunningNotification();
    } else if (data.values.first == 'BgService.RUNNING') {
      setBgServiceRunningNotification();
    }
  }
}

setZeroNetRunningNotification() {
  service.setNotificationInfo(
    title: "ZeroNet Mobile is Running",
    content: "Click Here on this Notification to open app",
  );
}

setBgServiceRunningNotification() {
  service.setNotificationInfo(
    title: "ZeroNet Mobile is Not Running",
    content: "Open ZeroNet Mobile App and click start to run ZeroNet",
  );
}

void onBgServiceDataReceived(Map<String, dynamic> data) {
  if (data.keys.first == 'status') {
    service.sendData({'notification': 'BgService.RUNNING'});
    service.sendData({
      'init': {
        'zeroNetNativeDir': zeroNetNativeDir,
        'zeroNetStartedFromBoot': false,
        'debugZeroNetCode':
            (varStore.settings[debugZeroNet] as ToggleSetting).value,
        'vibrateOnZeroNetStart':
            (varStore.settings[vibrateOnZeroNetStart] as ToggleSetting).value,
      }
    });
    if (zeroNetNativeDir.isEmpty || zeroNetNativeDir == null) {
      printToConsole('zeroNetNativeDir is Empty');
    } else if ((varStore.settings[autoStartZeroNet] as ToggleSetting).value ==
        true) {
      service.sendData({'cmd': 'runZeroNet'});
    }
  } else if (data.keys.first == 'ZeroNetStatus') {
    switch (data.values.first) {
      case 'INITIALISING':
        uiStore.setZeroNetStatus(ZeroNetStatus.INITIALISING);
        break;
      case 'ERROR':
        uiStore.setZeroNetStatus(ZeroNetStatus.ERROR);
        break;
      default:
    }
  } else if (data.keys.first == 'console') {
    printToConsole(data.values.first);
  }
}

shutDownZeronet() {
  if (uiStore.zeroNetStatus == ZeroNetStatus.RUNNING) {
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
    service.sendData({'cmd': 'shutDownZeronet'});
    zeroNetUrl = '';
    uiStore.setZeroNetStatus(ZeroNetStatus.NOT_RUNNING);
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
        // ZeroNet.wrapperKey = value;
        varStore.zeroNetWrapperKey = value;
        browserUrl = zeroNetUrl;
      }
    });
  } else {
    // ZeroNet.wrapperKey = varStore.zeroNetWrapperKey;
    browserUrl = zeroNetUrl;
  }
}

restartZeroNet() {
  ZeroNet.instance.shutDown();
  service.sendData({'cmd': 'runZeroNet'});
}

writeZeroNetConf(String str) {
  File f = File(zeroNetDir + '/zeronet.conf');
  if (f.existsSync()) {
    f.writeAsStringSync('\n' + str, mode: FileMode.append);
  } else {
    f.writeAsStringSync('[global]\n$str');
  }
}

bool isZeroNetUserDataExists() {
  return getZeroNetUsersFilePath().isNotEmpty;
}

bool isZeroNetUsersFileExists() {
  var dataDir = getZeroNetDataDir();
  if (dataDir.existsSync()) {
    File f = File(dataDir.path + '/users.json');
    return f.existsSync();
  } else {
    return false;
  }
}

String getZeroNetUsersFilePath() {
  var dataDir = getZeroNetDataDir();
  if (dataDir.existsSync()) {
    File f = File(dataDir.path + '/users.json');
    bool exists = f.existsSync();
    if (exists) {
      return f.path;
    }
  }
  return '';
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
    for (var item in getZeroNetDataDir().listSync().where(
        (element) => element.path.endsWith('.json') && element is File)) {
      var name = item.path.replaceAll(getZeroNetDataDir().path + '/', '');
      if (name.startsWith('users-')) {
        var username = name.replaceAll('users-', '').replaceAll('.json', '');
        list.add(username);
      }
    }
  return list;
}

String getZeroIdUserName() {
  File file = File(getZeroNetUsersFilePath());
  if (!file.existsSync()) return '';
  Map map = json.decode(file.readAsStringSync());
  var key = map.keys.first;
  Map certMap = map[key]['certs'];
  var certs = [];
  if (certMap.keys.length < 1)
    return '';
  else {
    for (var cert in certMap.keys) {
      certs.add(cert);
      var t = certMap[cert];
      if (t != null) {
        return certMap[cert]['auth_user_name'] ?? '';
      }
    }
  }
  return '';
}

bool isZiteExitsLocally(String address) {
  String path = getZeroNetDataDir().path + '/$address';
  return Directory(path).existsSync();
}

bool isLocalZitesExists() {
  String path = getZeroNetDataDir().path;
  Directory dir = Directory(path);

  List paths;
  if (dir.existsSync())
    paths = dir
        .listSync()
        .where((element) => (element is Directory) ? true : false)
        .toList();
  else
    return false;
  return paths.isNotEmpty;
}
