import '../imports.dart';

Future checkInitStatus() async {
  loadSitesFromFileSystem();
  loadUsersFromFileSystem();
  setZeroBrowserThemeValues();
  try {
    var url = '';
    var address = '';
    if (Directory(getZeroNetDataDir().path + '/' + Utils.urlZeroNetMob)
        .existsSync()) {
      address = Utils.urlHello;
    } else {
      address = Utils.urlZeroNetMob;
    }
    url = defZeroNetUrl + address;
    String key = await ZeroNet.instance.getWrapperKey(url);
    zeroNetUrl = defZeroNetUrl;
    varStore.zeroNetWrapperKey = key;
    // zeroNetIPwithPort(defZeroNetUrl),
    ZeroNet.instance.connect(address).catchError(
      (onError) {
        printToConsole(onError);
      },
    );
    uiStore.setZeroNetStatus(ZeroNetStatus.RUNNING);
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
      if (info.updateAvailability == UpdateAvailability.updateAvailable &&
          info.flexibleUpdateAllowed)
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
  var zeroNetUsersFilePath = getZeroNetUsersFilePath();
  if (zeroNetUsersFilePath.isEmpty) return '';
  File file = File(zeroNetUsersFilePath);
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

Future<bool> activateFilters() async {
  File file = File(getZeroNetDataDir().path + '/filters.json');
  File fileTemp = File(getZeroNetDataDir().path + '/filters-tmp.json');
  if (!file.existsSync() || fileTemp.existsSync()) {
    File deFile = File(getZeroNetDataDir().path + '/filters.json-deactive');
    if (deFile.existsSync()) {
      deFile.renameSync(getZeroNetDataDir().path + '/filters.json');
      return true;
    } else {
      await saveInAppFilterstoDevice();
      var filtersFileName = '';
      var filtersPath =
          getZeroNetDataDir().path + '/${Utils.urlZeroNetMob}/filters/';
      int len = 0;
      var directory = Directory(filtersPath);
      if (directory.existsSync()) len = directory.listSync().length;
      if (len >= 4) {
        filtersFileName = 'assets/filters/filters.json';
        fileTemp.deleteSync(recursive: true);
      } else {
        filtersFileName = 'assets/filters/filters-tmp.json';
        await saveFilterstoDevice(fileTemp, filtersFileName);
      }
      return await saveFilterstoDevice(file, filtersFileName);
    }
  }
  return true;
}

Future<bool> deactivateFilters() async {
  File file = File(getZeroNetDataDir().path + '/filters.json');
  if (file.existsSync()) {
    file.renameSync(getZeroNetDataDir().path + '/filters.json-deactive');
  }
  return true;
}

Future<bool> saveInAppFilterstoDevice() async {
  for (var filterName in filterFileNames) {
    File file = File(
      getZeroNetDataDir().path + '/tmp/filters/$filterName',
    );
    if (!file.existsSync()) {
      await saveFilterstoDevice(file, 'assets/filters/$filterName');
    }
  }
  return true;
}

Future<bool> saveFilterstoDevice(File file, String assetPath) async {
  file.createSync(recursive: true);
  var data = (await rootBundle.load(assetPath));
  var buffer = data.buffer;
  file.writeAsBytesSync(buffer.asUint8List(
    data.offsetInBytes,
    data.lengthInBytes,
  ));
  return true;
}

Future<bool> createTorDataDir() {
  Directory torDir = Directory(dataDir + '/usr/var/lib/tor');
  if (!torDir.existsSync()) torDir.createSync();
  return Future.value(true);
}

int getZeroNetRevision(String zeroNetDir) {
  var file = File(zeroNetDir + '/src/Config.py');
  var content = file.readAsStringSync();
  var versionIndex = content.indexOf('self.rev = ');
  var version = content.substring(versionIndex + 11, versionIndex + 15);
  return int.parse(version);
}

String getZeroNetVersion(String zeroNetDir) {
  var file = File(zeroNetDir + '/src/Config.py');
  var content = file.readAsStringSync();
  var versionIndex = content.indexOf('self.version = "');
  content = content.substring(versionIndex + 16);
  var endindex = content.indexOf('"');
  var version = content.substring(0, endindex);
  return version;
}

bool checkPatchNeeded() {
  var zeroNetVersion = getZeroNetVersion(zeronetDir);
  var zeroNetRevision = getZeroNetRevision(zeronetDir);
  if (zeroNetRevision == 4555 && zeroNetVersion == '0.7.2') {
    return true;
  } else if (zeroNetRevision == 4556 && zeroNetVersion == '0.7.2-v3patched') {
    return false;
  }
  return false;
}

Future<void> downloadPatch(String version) async {
  File patchFile = File(tempDir.path + '/$version.zip');
  if (!patchFile.existsSync()) {
    await downloadFile(zpatches, '$version.zip', tempDir.path);
  }
  Directory dir = Directory(tempDir.path + '/patches/$version');
  if (!dir.existsSync()) {
    unzipBytes(version, patchFile.readAsBytesSync(),
        dest: '${tempDir.path}/patches/$version/');
  }
}

Future<String> downloadFile(String url, String fileName, String dir) async {
  HttpClient httpClient = HttpClient();
  File file;
  String filePath = '';
  String myUrl = '';

  try {
    myUrl = url + '/' + fileName;
    var request = await httpClient.getUrl(Uri.parse(myUrl));
    var response = await request.close();
    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      filePath = '$dir/$fileName';
      file = File(filePath);
      await file.writeAsBytes(bytes);
    } else
      filePath = 'Error code: ' + response.statusCode.toString();
  } catch (ex) {
    filePath = 'Can not fetch url';
  }

  return filePath;
}

void checkPatchAndApply(String patchPath, String zeroNetPath) {
  var zeroNetVersion = getZeroNetVersion(zeroNetPath);
  var zeroNetRevision = getZeroNetRevision(zeroNetPath);

  if (zeroNetRevision == 4555 && zeroNetVersion == '0.7.2') {
    printOut('Applying patch for 0.7.2');
    applyPatch(patchPath, zeroNetPath);
  } else if (zeroNetRevision == 4555 && zeroNetVersion == '0.7.2-torv3') {
    printOut('Patch Already Applied for 0.7.2');
  }
}

void applyPatch(String patchPath, String destination) {
  var patchManifestFile = File(
    patchPath + '/patch.manifest',
  ).readAsStringSync();
  var contents = patchManifestFile.split('\n');
  for (var line in contents) {
    if (line.startsWith('[{D_}]')) {
      var filePath = line.replaceAll('[{D_}]', '');
      var file = File(destination + '/' + filePath);
      try {
        file.deleteSync();
      } catch (e) {
        print(e);
      }
    } else if (line.startsWith('[{A_}]')) {
      var name = line.replaceAll('[{A_}]', '');
      var file = File(patchPath + '/' + name);
      if (!file.existsSync()) {
        // throw Exception('File does not exist');
      }
      var p = File(destination + '/' + name).parent;
      if (!p.existsSync()) {
        p.createSync();
      }
      File(file.path).copySync(destination + '/' + name);
    } else if (line.startsWith('[{R_}]')) {
      var params = line.replaceAll('[{R_}]', '').split('][');
      var oldname = params[0].replaceAll('[', '');
      var newname = params[1].replaceAll(']', '');
      if (oldname.endsWith('/') && newname.endsWith('/')) {
        try {
          Directory(destination + '/' + oldname).renameSync(
            destination + '/' + newname,
          );
        } catch (e) {
          print(e);
        }
      } else {
        try {
          File(destination + '/' + oldname).renameSync(
            destination + '/' + newname,
          );
        } catch (e) {
          print(e);
        }
      }
    } else if (line.startsWith('[{M_}]')) {
      var path = line.replaceAll('[{M_}]', '');
      var patchFile = File(patchPath + '/' + path + '.patch');
      var destinationFile = File(destination + '/' + path);
      var p = patchFromText(patchFile.readAsStringSync());

      var dmp = DiffMatchPatch();
      // var diff = dmp.diff(orgContent, patchedContent);
      var result = dmp.patch_apply(p, destinationFile.readAsStringSync());
      print('\n' + result[1].toString() + '\n');
      if (!(result[1] as List<bool>).contains(false)) {
        destinationFile.writeAsString(result[0]);
      }
    }
  }
}
