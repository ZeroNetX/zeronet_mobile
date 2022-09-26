import 'dart:ui' show DartPluginRegistrant;

import '../imports.dart';

void runTorEngine() {
  service = ZeroNetService();
  final tor = zeroNetNativeDir! + '/libtor.so';
  if (File(tor).existsSync()) {
    service.sendData({'console': 'Running Tor Engine..'});
    Process.start('$tor', [], environment: {
      "LD_LIBRARY_PATH": "$libDir:$libDir64:/system/lib64",
    }).then((proc) {
      zero = proc;
      if (enableTorLogConsole!) {
        zero.stderr.listen((onData) {
          service.sendData({'console': utf8.decode(onData)});
        });
        zero.stdout.listen((onData) {
          service.sendData({'console': utf8.decode(onData)});
        });
      }
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

void runZeroNet() {
  printOut('runZeroNet()');
  printOut('zeroNetStatus : ${uiStore.zeroNetStatus.value}');
  // if (zeroNetNativeDir.isEmpty) {
  //   printOut('zeroNetNativeDir.isEmpty : ${zeroNetNativeDir.isEmpty}');
  //   getNativeDir().then((nativeDir) {
  //     zeroNetNativeDir = nativeDir;
  //     runZeroNet();
  //   });
  // } else {
  if (uiStore.zeroNetStatus.value == ZeroNetStatus.NOT_RUNNING ||
      uiStore.zeroNetStatus.value == ZeroNetStatus.ERROR) {
    uiStore.setZeroNetStatus(ZeroNetStatus.INITIALISING);
    service.sendData({'ZeroNetStatus': 'INITIALISING'});
    runTorEngine();
    log = '';
    service.sendData({'console': logRunning});
    service.sendData({'console': startZeroNetLog + '\n'});
    if (Platform.isAndroid) {
      var python = zeroNetNativeDir! + '/libpython3.8.so';
      var openssl = zeroNetNativeDir! + '/libopenssl.so';
      var trackerFile = trackersDir.path + '/${trackerFileNames[0]}';
      printOut('python file : $python');
      printOut('openssl file : $openssl');
      if (File(python).existsSync()) {
        Process.start('$python', [
          zeronet,
          if (debugZeroNetCode!) '--debug',
          "--start_dir",
          zeroNetDir,
          "--openssl_bin_file",
          openssl,
          if (enableZeroNetAddTrackers!) '--trackers_file',
          if (enableZeroNetAddTrackers!) trackerFile,
          "--updatesite",
          "1Update8crprmciJHwp2WXqkx2c4iYp18"
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
        if (zeroNetNativeDir!.isNotEmpty) {
          var contents = Directory(zeroNetNativeDir!).listSync(recursive: true);
          for (var item in contents) {
            service.sendData({'console': item.name});
            service.sendData({'console': item.path});
          }
        } else {
          service.sendData({'console': 'Initialising ZeroNet'});
        }
      }
      // service.sendData({'ZeroNetStatus': 'RUNNING'});
    } else {
      //TODO: Add more arguments here and modify process script
      var zeronet = zeroNetNativeDir! + sep + 'ZeroNet.exe';
      // var openssl = zeroNetNativeDir + '/libopenssl.so';
      // var trackerFile = trackersDir.path + '/${trackerFileNames[0]}';
      printOut('zeronet file : $zeronet');
      // printOut('openssl file : $openssl');
      if (File(zeronet).existsSync()) {
        Process.start('$zeronet', [
          // zeronet,
          // if (debugZeroNetCode) '--debug',
          "--start_dir",
          zeroNetDir,
          "--data_dir",
          getZeroNetDataDir().path,
          "--open_browser",
          "False",
          // "--openssl_bin_file",
          // // openssl,
          // if (enableZeroNetAddTrackers) '--trackers_file',
          // if (enableZeroNetAddTrackers) trackerFile,
          // "--updatesite",
          // "1Update8crprmciJHwp2WXqkx2c4iYp18"
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
        if (zeroNetNativeDir!.isNotEmpty) {
          var contents = Directory(zeroNetNativeDir!).listSync(recursive: true);
          for (var item in contents) {
            service.sendData({'console': item.name});
            service.sendData({'console': item.path});
          }
        } else {
          service.sendData({'console': 'Initialising ZeroNet'});
        }
      }
    }
  } else {
    shutDownZeronet();
  }
}

void runZeroNetService({bool autoStart = false}) async {
  printOut('runZeroNetService()');
  bool? autoStartService = autoStart
      ? true
      : (varStore.settings[autoStartZeroNetonBoot] as ToggleSetting).value;
  bool filtersEnabled =
      (varStore.settings[enableZeroNetFilters] as ToggleSetting).value ?? true;
  if (filtersEnabled) await activateFilters();
  printToConsole(startZeroNetLog);
  //TODO?: Check for Bugs Here.
  bool serviceRunning = false;
  if (PlatformExt.isMobile || !serviceRunning) {
    service = ZeroNetService();
    serviceRunning = await service.isServiceRunning;
    uiStore.setZeroNetStatus(ZeroNetStatus.NOT_RUNNING);
  }
  printOut('serviceRunning : $serviceRunning');

  service.configure(runBgIsolate, autoStart: autoStartService).then(
    (value) {
      printOut('FlutterBackgroundService.initialize() : $value');
      if (value) {
        service = ZeroNetService();
        service.onDataReceived.listen(onBgServiceDataReceived);
        if (zeroNetNativeDir!.isNotEmpty) saveDataFile();
        if (Platform.isAndroid) {
          uiStore.setZeroNetStatus(ZeroNetStatus.INITIALISING);
          service.sendData({'cmd': 'runZeroNet'});
          runBgIsolate();
        } else {
          runBgIsolate();
        }
      }
    },
  );
}

void runBgIsolate() {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  service = ZeroNetService();
  service.onDataReceived.listen(onBgServiceDataReceivedForIsolate);
  service.sendData({'status': 'Started Background Service Successfully'});
  Timer(Duration(milliseconds: 0), () {
    if (PlatformExt.isMobile) {
      if (zeroNetStartedFromBoot! || zeroNetNativeDir!.isEmpty) {
        setBgServiceRunningNotification();
        if (zeroNetNativeDir!.isEmpty || zeroNetNativeDir == null) {
          loadSettings();
          loadDataFile();
          debugZeroNetCode =
              (varStore.settings[debugZeroNet] as ToggleSetting).value;
          enableTorLogConsole =
              (varStore.settings[enableTorLog] as ToggleSetting).value;
          enableZeroNetAddTrackers =
              (varStore.settings[enableAdditionalTrackers] as ToggleSetting)
                  .value;
          vibrateonZeroNetStart =
              (varStore.settings[vibrateOnZeroNetStart] as ToggleSetting).value;
          printOut('runBgIsolate() > runZeroNet()');
          runZeroNet();
          setZeroNetRunningNotification();
        }
      }
    } else {
      setBgServiceRunningNotification();
      loadSettings();
      loadDataFile();
      debugZeroNetCode =
          (varStore.settings[debugZeroNet] as ToggleSetting).value;
      enableTorLogConsole =
          (varStore.settings[enableTorLog] as ToggleSetting).value;
      enableZeroNetAddTrackers =
          (varStore.settings[enableAdditionalTrackers] as ToggleSetting).value;
      vibrateonZeroNetStart =
          (varStore.settings[vibrateOnZeroNetStart] as ToggleSetting).value;
      printOut('runBgIsolate() > runZeroNet()');
      runZeroNet();
      setZeroNetRunningNotification();
    }
  });
}

void onBgServiceDataReceivedForIsolate(Map<String, dynamic>? data) {
  if (data!.keys.first == 'cmd') {
    switch (data.values.first) {
      case 'runZeroNet':
        printOut('onBgServiceDataReceivedForIsolate() > runZeroNet()');
        runZeroNet();
        break;
      case 'shutDownZeronet':
        service.stop();
        uiStore.setZeroNetStatus(ZeroNetStatus.NOT_RUNNING);
        break;
      default:
    }
  } else if (data.keys.first == 'init') {
    Map initMap = data['init'];
    zeroNetNativeDir = initMap['zeroNetNativeDir'];
    debugZeroNetCode = initMap['debugZeroNetCode'];
    enableTorLogConsole = initMap['enableTorLog'];
    zeroNetStartedFromBoot = initMap['zeroNetStartedFromBoot'];
    vibrateonZeroNetStart = initMap['vibrateOnZeroNetStart'];
    enableZeroNetAddTrackers = initMap['enableAdditionalTrackers'];
    setBgServiceRunningNotification();
  } else if (data.keys.first == 'notification') {
    if (data.values.first == 'ZeroNetStatus.RUNNING') {
      setZeroNetRunningNotification();
    } else if (data.values.first == 'BgService.RUNNING') {
      setBgServiceRunningNotification();
    }
  }
}

void setZeroNetRunningNotification() {
  service.setNotificationInfo(
    title: strController.znNotiRunningTitleStr.value,
    content: strController.znNotiRunningDesStr.value,
  );
}

void setBgServiceRunningNotification() {
  service.setNotificationInfo(
    title: strController.znNotiNotRunningTitleStr.value,
    content: strController.znNotiNotRunningDesStr.value,
  );
}

void onBgServiceDataReceived(Map<String, dynamic>? data) {
  if (data!.keys.first == 'status') {
    service.sendData({'notification': 'BgService.RUNNING'});
    service.sendData({
      'init': {
        'zeroNetNativeDir': zeroNetNativeDir,
        'zeroNetStartedFromBoot': false,
        'debugZeroNetCode':
            (varStore.settings[debugZeroNet] as ToggleSetting).value,
        'enableTorLog':
            (varStore.settings[enableTorLog] as ToggleSetting).value,
        'vibrateOnZeroNetStart':
            (varStore.settings[vibrateOnZeroNetStart] as ToggleSetting).value,
        'enableAdditionalTrackers':
            (varStore.settings[enableAdditionalTrackers] as ToggleSetting)
                .value,
      }
    });
    if (zeroNetNativeDir!.isEmpty || zeroNetNativeDir == null) {
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
      case 'RUNNING':
        uiStore.setZeroNetStatus(ZeroNetStatus.RUNNING);
        runZeroNetWs();
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

void runZeroNetWs({String? address}) {
  var zeroNetUrlL = zeroNetUrl.isNotEmpty ? zeroNetUrl : defZeroNetUrl;
  zeroNetUrl = zeroNetUrlL;
  if (varStore.zeroNetWrapperKey.isEmpty) {
    try {
      ZeroNet.instance
          .getWrapperKey(
        zeroNetUrl + Utils.urlHello,
        override: true,
      )
          .then(
        (value) {
          if (uiStore.zeroNetStatus.value != ZeroNetStatus.RUNNING) {
            uiStore.setZeroNetStatus(ZeroNetStatus.RUNNING_WITH_TOR);
          }
          varStore.zeroNetWrapperKey = value;
          browserUrl = zeroNetUrl;
          ZeroNet.instance.connect(address ?? Utils.urlHello, override: true);
        },
      );
    } catch (e) {
      // printToConsole(e);
    }
  } else {
    // ZeroNet.wrapperKey = varStore.zeroNetWrapperKey;
    browserUrl = zeroNetUrl;
  }
}

void restartZeroNet() {
  //TODO: Handle Shutdown
  // ZeroNet.instance.shutDown();
  service.sendData({'cmd': 'runZeroNet'});
}

void shutDownZeronet() {
  if (uiStore.zeroNetStatus.value == ZeroNetStatus.RUNNING) {
    service.sendData({'cmd': 'shutDownZeronet'});
    runZeroNetWs();
    if (ZeroNet.isInitialised) {
      //TODO: Handle Shutdown
      ZeroNet.instance.serverShutdownFuture().then(
            (value) => ZeroNet.instance.respond(
              to: value.id,
            ),
          );
    } else {
      runZeroNetWs(address: Utils.urlHello);
      try {
        //TODO: Handle Shutdown
        ZeroNet.instance.serverShutdownFuture().then(
              (value) => ZeroNet.instance.respond(
                to: value.id,
              ),
            );
      } catch (e) {
        printOut(e);
      }
    }
    zeroNetUrl = '';
    uiStore.setZeroNetStatus(ZeroNetStatus.NOT_RUNNING);
  }
}
