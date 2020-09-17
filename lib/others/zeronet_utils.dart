import 'dart:convert';
import 'dart:io';

import 'package:zeronet/core/site/site_manager.dart';
import 'package:zeronet/core/user/user_manager.dart';
import 'package:zeronet/mobx/uistore.dart';
import 'package:zeronet_ws/zeronet_ws.dart';

import '../mobx/varstore.dart';
import '../models/models.dart';
import '../others/utils.dart';
import 'common.dart';
import 'constants.dart';
import 'extensions.dart';
import 'native.dart';

checkInitStatus() async {
  try {
    String url = defZeroNetUrl + Utils.initialSites['ZeroNetMobile']['url'];
    String key = await ZeroNet.instance.getWrapperKey(url);
    zeroNetUrl = defZeroNetUrl;
    varStore.zeroNetWrapperKey = key;
    // varStore.setZeroNetStatus('Running');
    uiStore.setZeroNetStatus(ZeroNetStatus.RUNNING);
    ZeroNet.instance.connect(
      zeroNetIPwithPort(defZeroNetUrl),
      Utils.urlZeroNetMob,
    );
    showZeroNetRunningNotification(enableVibration: false);
    testUrl();
  } catch (e) {
    if (!firstTime &&
        (varStore.settings[autoStartZeroNet] as ToggleSetting).value == true) {
      //TODO: Remember this!
      runZeroNet();
    }
    if (e is OSError) {
      if (e.errorCode == 111) {
        printToConsole('Zeronet Not Running');
        uiStore.setZeroNetStatus(ZeroNetStatus.NOT_RUNNING);
      }
    }
  }
  loadSitesFromFileSystem();
  loadUsersFromFileSystem();
  setZeroBrowserThemeValues();
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
    zeroBrowserTheme = usersAvailable.first.settings.theme;
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
  } else {
    //TODO: Improve Error Trace here
    printToConsole('Tor Binary Not Found');
    uiStore.setZeroNetStatus(ZeroNetStatus.RUNNING);
  }
}

runZeroNet() {
  if (uiStore.zeroNetStatus == ZeroNetStatus.NOT_RUNNING) {
    uiStore.setZeroNetStatus(ZeroNetStatus.INITIALISING);
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
        uiStore.setZeroNetStatus(ZeroNetStatus.ERROR);
      });
    } else {
      //TODO: Improve Error Trace here
      printToConsole('Python Binary Not Found');
      uiStore.setZeroNetStatus(ZeroNetStatus.ERROR);
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
    zeroNetUrl = '';
    uiStore.setZeroNetStatus(ZeroNetStatus.NOT_RUNNING);
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
            // printOut(username);
          }
        }
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
