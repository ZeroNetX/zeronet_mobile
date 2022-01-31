import 'package:purchases_flutter/purchases_flutter.dart';

import '../imports.dart';
import 'zeronet_isolate.dart';

Directory appPrivDir;
Directory tempDir;
Directory metaDir = Directory(dataDir + '/meta');
Directory trackersDir = Directory(dataDir + '/trackers');
AndroidDeviceInfo deviceInfo;
bool isZeroNetInstalledm = false;
bool isZeroNetDownloadedm = false;
bool isDownloadExec = false;
bool canLaunchUrl = false;
bool firstTime = false;
bool kisProUser = false;
bool patchChecked = false;
bool fromBrowser = false;
bool kIsPlayStoreInstall = false;
bool kEnableInAppPurchases = !kDebugMode && kIsPlayStoreInstall;
bool manuallyStoppedZeroNet = false;
bool zeroNetStartedFromBoot = true;
bool isExecPermitted = false;
bool debugZeroNetCode = false;
bool enableTorLogConsole = false;
bool vibrateonZeroNetStart = false;
bool enableZeroNetAddTrackers = false;
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
String launchUrl = '';
String zeroNetNativeDir = '';
String zeroNetIPwithPort(String url) =>
    url.replaceAll('http:', '').replaceAll('/', '').replaceAll('s', '');
String sesionKey = '';
String browserUrl = 'https://google.com';
Map<String, Site> sitesAvailable = {};
List<User> usersAvailable = [];
String zeroBrowserTheme = 'light';
String snackMessage = '';

FlutterBackgroundService service;

String downloadLink(String item) =>
    releases + 'Android_Module_Binaries/$item.zip';

String trackerRepo = 'https://newtrackon.com/api/';
String downloadTrackerLink(String item) => trackerRepo + item;

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
      'python38_$arch',
      if (arch != 'arm64') 'site_packages_common',
      'site_packages_$arch',
      'zeronet_py3',
      'tor_$arch',
    ];

List<String> trackerFileNames = [
  'stable',
];

void setSystemUiTheme() => SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: uiStore.currentTheme.value.iconBrightness,
        systemNavigationBarColor: uiStore.currentTheme.value.primaryColor,
        systemNavigationBarIconBrightness:
            uiStore.currentTheme.value.iconBrightness,
      ),
    );

init() async {
  getArch();
  await getPackageInfo();
  if (Platform.isAndroid) {
    kIsPlayStoreInstall = await isPlayStoreInstall();
    zeroNetNativeDir = await getNativeDir();
    tempDir = await getTemporaryDirectory();
    appPrivDir = await getExternalStorageDirectory();
  } else if (Platform.isWindows) {
    var appDir = File(Platform.resolvedExecutable).parent;
    var directory = Directory(appDir.path + Platform.pathSeparator + 'bin');

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    zeroNetNativeDir = directory.path;

    tempDir = Directory(appDir.path + Platform.pathSeparator + 'tmp');
    if (!tempDir.existsSync()) {
      tempDir.createSync(recursive: true);
    }
    appPrivDir = Directory(appDir.path +
        Platform.pathSeparator +
        'data' +
        Platform.pathSeparator +
        'app');
    if (!appPrivDir.existsSync()) {
      appPrivDir.createSync(recursive: true);
    }
  }
  loadSettings();
  isZeroNetInstalledm = await isZeroNetInstalled();
  if (isZeroNetInstalledm) {
    varStore.isZeroNetInstalled(isZeroNetInstalledm);
    checkForAppUpdates();
    if (enableZeroNetAddTrackers) await downloadTrackerFiles();
    ZeroNetStatus.NOT_RUNNING.onAction();
  }
  if (!tempDir.existsSync()) tempDir.createSync(recursive: true);
  Purchases.setup("ShCpAJsKdJrAAQawcMQSswqTyPWFMwXb");
  var translations = loadTranslations();
  if (varStore.settings.keys.contains(languageSwitcher)) {
    var setting = varStore.settings[languageSwitcher] as MapSetting;
    var language = setting.map['selected'];
    var code = translations[language] ?? 'en';
    if (code != 'en')
      strController.loadTranslationsFromFile(
        getZeroNetDataDir().path +
            '/' +
            Utils.urlZeroNetMob +
            '/translations/' +
            'strings-$code.json',
      );
  }
  loadUsersFromFileSystem();
  if (varStore.settings.keys.contains(themeSwitcher)) {
    var setting = varStore.settings[themeSwitcher] as MapSetting;
    var theme = setting.map['selected'];
    if (theme == 'Dark') {
      uiStore.setTheme(AppTheme.Dark);
    } else {
      uiStore.setTheme(AppTheme.Light);
    }
  }
  kisProUser = await isProUser();
}

List<int> buildsRequirePatching = [60];

bool requiresPatching() {
  return buildsRequirePatching.contains(int.parse(buildNumber));
}

Future<void> getPackageInfo() async {
  packageInfo = await PackageInfo.fromPlatform();
  appVersion = packageInfo.version;
  buildNumber = packageInfo.buildNumber;
}

void listMetaFiles() {
  Directory metaDirs = Directory(metaDir.path);
  var files = metaDirs.listSync();
  for (var item in files) {
    print(item.path);
  }
}

Future<File> pickUserJsonFile() async {
  FilePickerResult result = await pickFile(fileExts: ['json']);
  if (result == null) return null;
  File file = File(result.files.single.path);
  return file;
}

Future<File> pickPluginZipFile() async {
  FilePickerResult result = await pickFile(fileExts: ['zip']);
  if (result == null) return null;
  File file = File(result.files.single.path);
  return file;
}

Future<FilePickerResult> pickFile({List<String> fileExts}) async {
  FilePickerResult result = await FilePicker.platform.pickFiles(
    type: FileType.any,
    allowedExtensions: fileExts,
  );

  return result;
}

Future<void> backUpUserJsonFile(
  BuildContext context, {
  bool copyToClipboard = false,
}) async {
  if (getZeroNetUsersFilePath().isNotEmpty) {
    if (copyToClipboard) {
      FlutterClipboard.copy(File(getZeroNetUsersFilePath()).readAsStringSync())
          .then(
        (_) {
          printToConsole(strController.usersFileCopied.value);
          Get.showSnackbar(GetBar(
            message: strController.usersFileCopied.value,
          ));
        },
      );
    } else {
      String result = await saveUserJsonFile(getZeroNetUsersFilePath());
      Get.showSnackbar(GetBar(
        message: (result.contains('success'))
            ? result
            : strController.chkBckUpStr.value,
      ));
    }
  } else
    zeronetNotInit(context);
}

void zeronetNotInit(BuildContext context) => showDialogC(
      context: context,
      title: strController.zeroNetNotInitTitleStr.value,
      body: strController.zeroNetNotInitDesStr.value,
    );

Map<String, dynamic> loadTranslations() {
  Map<String, dynamic> langCodesMap = {};
  var translationsDir = Directory(
    getZeroNetDataDir().path + '/' + Utils.urlZeroNetMob + '/translations',
  );
  if (translationsDir.existsSync()) {
    var langCodeFile = File(translationsDir.path + '/language-codes.json');
    if (langCodeFile.existsSync()) {
      langCodesMap = json.decode(langCodeFile.readAsStringSync());
    }
  }
  return langCodesMap;
}

saveDataFile() {
  Map<String, String> dataMap = {
    'zeroNetNativeDir': zeroNetNativeDir,
  };
  File f = File(dataDir + '/data.json');
  f.writeAsStringSync(json.encode(dataMap));
}

loadDataFile() {
  File f = File(dataDir + '/data.json');
  Map m = json.decode(f.readAsStringSync());
  printOut(m);
  zeroNetNativeDir = m['zeroNetNativeDir'];
}

loadSettings() {
  File f = File(dataDir + '/settings.json');
  List settings;
  if (f.existsSync()) {
    settings = json.decode(f.readAsStringSync());
    if (settings.length < Utils.defSettings.keys.length) {
      List settingsKeys = [];
      Map<String, Setting> m = {};
      for (var i = 0; i < settings.length; i++) {
        var k = (settings[i] as Map)['name'];
        settingsKeys.add(k);
        Map map = settings[i];
        if (map.containsKey('value')) {
          m[k] = ToggleSetting().fromJson(map);
        }
      }
      for (var key in Utils.defSettings.keys) {
        if (!settingsKeys.contains(key)) {
          m[key] = Utils.defSettings[key];
        }
      }
      saveSettings(m);
      settings = json.decode(maptoStringList(m));
    }
  } else {
    firstTime = true;
    saveSettings(Utils.defSettings);
    settings = json.decode(maptoStringList(Utils.defSettings));
  }
  for (var i = 0; i < settings.length; i++) {
    Map map = settings[i];
    if (map.containsKey('value')) {
      varStore.updateSetting(ToggleSetting().fromJson(map));
    } else if (map.containsKey('map')) {
      varStore.updateSetting(MapSetting().fromJson(map));
    }
  }
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
String logRunning = '${strController.statusRunningStr.value} ZeroNet\n';
String uiServerLog = 'Ui.UiServer';
String startZeroNetLog = '${strController.statusStartingStr.value} ZeroNet';
Process zero;

printToConsole(Object object) {
  if (object is String) {
    if (!object.contains(startZeroNetLog)) {
      printOut(object);
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
      if (object.contains('Ui.UiServer Web interface: ') ||
          object.contains('Server port opened') ||
          object.contains(zeronetAlreadyRunningError)) {
        runZeroNetWs();
        uiStore.setZeroNetStatus(ZeroNetStatus.RUNNING);
        service.sendData({'notification': 'ZeroNetStatus.RUNNING'});
      }
      if (object.contains('ConnServer Closed port') ||
          object.contains('All server stopped')) {
        zeroNetUrl = '';
        uiStore.setZeroNetStatus(ZeroNetStatus.NOT_RUNNING);
      }
      log = log + object + '\n';
    } else {
      log = startZeroNetLog + '\n';
      if (object.contains(zeronetAlreadyRunningError)) {
        runZeroNetWs();
        uiStore.setZeroNetStatus(ZeroNetStatus.RUNNING);
        service.sendData({'notification': 'ZeroNetStatus.RUNNING'});
      }
    }
  }
  varStore.setZeroNetLog(log);
}

void showDialogC({
  BuildContext context,
  String title = '',
  String body = '',
}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: uiStore.currentTheme.value.primaryTextColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(body),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(strController.closeStr.value),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

void showDialogW({
  BuildContext context,
  String title = '',
  Widget body,
  bool singleOption,
  Widget actionOk,
}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: uiStore.currentTheme.value.cardBgColor,
          title: Text(
            title,
            style: TextStyle(
              color: uiStore.currentTheme.value.primaryTextColor,
            ),
          ),
          content: SingleChildScrollView(
            child: body,
          ),
          actions: <Widget>[
            actionOk,
            TextButton(
              child: Text(strController.closeStr.value),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

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
            if (!unZipIsolateBound) bindUnZipIsolate();
            unZipinBg();
          }
        });
      }
    } else {
      isZeroNetInstalledm = await isZeroNetInstalled();
      if (!isZeroNetInstalledm) {
        isZeroNetDownloadedm = await isZeroNetDownloaded();
        if (isZeroNetDownloadedm) {
          varStore.isZeroNetDownloaded(true);
        } else {
          varStore.setLoadingStatus(downloading);
          if (!isDownloadExec) {
            if (await isModuleInstallSupported() &&
                kEnableDynamicModules &&
                await isPlayStoreInstall()) {
              await initSplitInstall();
              printOut(
                'PlayStore Module Install Supported',
                lineBreaks: 3,
                isNative: true,
              );
              if (await isRequiredModulesInstalled()) {
                printOut(
                  'Required Modules are Installed',
                  lineBreaks: 3,
                  isNative: true,
                );
                if (await copyAssetsToCache()) {
                  printOut(
                    'Assets Copied to Cache',
                    lineBreaks: 3,
                    isNative: true,
                  );
                  isZeroNetDownloadedm = true;
                  varStore.setLoadingStatus(installing);
                  varStore.setLoadingPercent(0);
                  check();
                }
              } else {
                printOut(
                  'Required Modules are not Installed, Installing',
                  lineBreaks: 3,
                  isNative: true,
                );
                handleModuleDownloadStatus();
              }
            } else {
              await initDownloadParams();
              downloadBins();
            }
          }
        }
      } else {
        varStore.isZeroNetInstalled(true);
      }
    }
  }
}

void installPluginDialog(File file, BuildContext context) {
  //TODO: Add Unzip listener for Plugin Install
  // _unZipPort.close();
  // bindUnZipIsolate();
  // _unZipPort.listen((data) {
  //   String name = data[0];
  //   int currentFile = data[1];
  //   int totalFiles = data[2];
  //   var percent = (currentFile / totalFiles) * 100;
  //   if (percent == 100) {
  //     if (name == 'plugin') {
  //       Navigator.pop(context);
  //     }
  //   }
  // });
  installPlugin(file);
  showDialogW(
    context: context,
    title: strController.znPluginInstallingTitleStr.value,
    body: Column(
      children: <Widget>[
        Text(
          strController.znPluginInstallingDesStr.value,
        ),
        Padding(padding: EdgeInsets.all(12.0)),
        LinearProgressIndicator()
      ],
    ),
    singleOption: true,
  );
  Timer(Duration(seconds: 5), () {
    Navigator.pop(context);
    restartZeroNet();
  });
}

testUrl() {
  if (zeroNetUrl.isNotEmpty) {
    canLaunch(zeroNetUrl).then((onValue) {
      canLaunchUrl = onValue;
    });
  }
}
