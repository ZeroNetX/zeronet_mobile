import '../imports.dart';

const String pkgName = 'in.canews.zeronetmobile${kDebugMode ? '.debug' : ''}';
const String dataDir = "/data/data/$pkgName/files";
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
const String facebookLink = 'https://facebook.com';
const String twitterLink = 'https://twitter.com';
const String githubLink = 'https://github.com';
const String rawGithubLink = 'https://raw.githubusercontent.com';
const String canewsInRepo = '/canewsin/ZeroNet';
const String zeromobileRepo = '/canewsin/zeronet_mobile';
const String releases = '$githubLink$canewsInRepo/releases/download/';
const String md5hashLink = '$rawGithubLink$canewsInRepo/py3-patches/md5.hashes';
const String zpatches = '$githubLink$zeromobileRepo/releases/download/patches';
const String zeroNetNotiId = 'zeroNetNetiId';
const String zeroNetChannelName = 'ZeroNet Mobile';
const String zeroNetChannelDes =
    'Shows ZeroNet Notification to Persist from closing.';
const String notificationCategory = 'ZERONET_RUNNING';
const String isolateUnZipPort = 'unzip_send_port';
const String isolateDownloadPort = 'downloader_send_port';
const String zeronetStartUpError = 'Startup error: ';
const String zeronetAlreadyRunningError =
    zeronetStartUpError + 'Can\'t open lock file';
const bool kEnableDynamicModules = !kDebugMode;

const List<Feature> unImplementedFeatures = [
  Feature.SITE_DELETE,
  Feature.SITE_PAUSE_RESUME,
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

const List<String> filterFileNames = [
  'sites-miners.json',
  'sites-porn.json',
  'users-porn.json',
  'users-spamlist.json',
];

const List<AppDeveloper> appDevelopers = [
  AppDeveloper(
    name: 'PramUkesh',
    developerType: 'developer',
    profileIconLink: 'assets/developers/pramukesh.jpg',
    githubLink: '$githubLink/PramUkesh/',
    facebookLink: '$facebookLink/n.bhargavvenky',
    twitterLink: '$twitterLink/PramukeshVenky',
  ),
  AppDeveloper(
    name: 'CANewsIn',
    developerType: 'organisation',
    profileIconLink: 'assets/developers/canewsin.jpg',
    githubLink: '$githubLink/canewsin/',
    facebookLink: '$facebookLink/canews.in',
    twitterLink: '$twitterLink/canewsin',
  ),
];

const String languageSwitcher = 'Language';
const String themeSwitcher = 'Theme';
const String profileSwitcher = 'Profile Switcher';
const String debugZeroNet = 'Debug ZeroNet Code';
const String enableZeroNetConsole = 'Enable ZeroNet Console';
const String enableZeroNetFilters = 'Enable ZeroNet Filters';
const String enableAdditionalTrackers = 'Additional BitTorrent Trackers';
const String pluginManager = 'Plugin Manager';
const String vibrateOnZeroNetStart = 'Vibrate on ZeroNet Start';
const String enableFullScreenOnWebView = 'FullScreen for ZeroNet Zites';
const String batteryOptimisation = 'Disable Battery Optimisation';
const String publicDataFolder = 'Public DataFolder';
const String autoStartZeroNet = 'AutoStart ZeroNet';
const String autoStartZeroNetonBoot = 'AutoStart ZeroNet on Boot';
const String enableTorLog = 'Enable Tor Log';

class Utils {
  static const String urlHello = '1HeLLo4uzjaLetFx6NH3PMwFP3qbRbTf3D';
  static const String urlZeroNetMob = '15UYrA7aXr2Nto1Gg4yWXpY3EAJwafMTNk';
  static const String urlTalk = 'Talk.ZeroNetwork.bit';
  static const String btcUrlTalk = '1TaLkFrMwvbNsooF4ioKAY9EuxTBTjipT';
  static const String urlBlog = 'Blog.ZeroNetwork.bit';
  static const String btcUrlBlog = '1BLogC9LN4oPDcruNz3qo1ysa133E9AGg8';
  static const String urlMail = 'Mail.ZeroNetwork.bit';
  static const String btcUrlMail = '1MaiL5gfBM1cyb4a8e3iiL8L5gXmoAJu27';
  static const String urlMe = 'Me.ZeroNetwork.bit';
  static const String btcUrlMe = '1MeFqFfFFGQfa1J3gJyYYUvb5Lksczq7nH';
  static const String urlSites = 'Sites.ZeroNetwork.bit';
  static const String btcUrlSites = '1SiTEs2D3rCBxeMoLHXei2UYqFcxctdwB';

  static var initialSites = {
    'ZeroHello': {
      'description': (strController.zerohelloSiteDesStr as RxString).value,
      'url': urlHello,
      'btcAddress': urlHello,
    },
    'ZeroNetMobile': {
      'description': (strController.zeronetMobileSiteDesStr as RxString).value,
      'url': urlZeroNetMob,
      'btcAddress': urlZeroNetMob,
    },
    'ZeroTalk': {
      'description': (strController.zeroTalkSiteDesStr as RxString).value,
      'url': urlTalk,
      'btcAddress': btcUrlTalk,
    },
    'ZeroBlog': {
      'description': (strController.zeroblogSiteDesStr as RxString).value,
      'url': urlBlog,
      'btcAddress': btcUrlBlog,
    },
    'ZeroMail': {
      'description': (strController.zeromailSiteDesStr as RxString).value,
      'url': urlMail,
      'btcAddress': btcUrlMail,
    },
    'ZeroMe': {
      'description': (strController.zeromeSiteDesStr as RxString).value,
      'url': urlMe,
      'btcAddress': btcUrlMe,
    },
    'ZeroSites': {
      'description': (strController.zeroSitesSiteDesStr as RxString).value,
      'url': urlSites,
      'btcAddress': btcUrlSites,
    },
  };

  // 'ZeroName': '1Name2NXVi1RDPDgf5617UoW7xA6YrhM9F',

  // static const String createProfile = 'Create'; // New Profile
  // static const String importProfile = 'Import'; // Profile
  // static const String backupProfile = 'Backup'; // Profile

  // static const String openPluginManager = 'Open Plugin Manager';
  // static const String loadPlugin = 'Load Custom Plugin';

  static Map<String, Setting> defSettings = {
    languageSwitcher: MapSetting(
      name: strController.languageSwitcherStr.value,
      description: strController.languageSwitcherDesStr.value,
      map: {
        "selected": '',
        "all": [],
      },
      options: [],
    ),
    themeSwitcher: MapSetting(
      name: strController.themeSwitcherStr.value,
      description: strController.themeSwitcherDesStr.value,
      map: {},
      options: [
        MapOptions.THEME_LIGHT,
        MapOptions.THEME_DARK,
        //! Premium fEATURE.
        // MapOptions.THEME_BLACK,
        //TODO: Add more themes
      ],
    ),
    profileSwitcher: MapSetting(
      name: strController.profileSwitcherStr.value,
      description: strController.profileSwitcherDesStr.value,
      map: {
        "selected": '',
        "all": [],
      },
      options: [
        MapOptions.CREATE_PROFILE,
        MapOptions.IMPORT_PROFILE,
        MapOptions.BACKUP_PROFILE,
      ],
    ),
    pluginManager: MapSetting(
        name: strController.pluginManagerStr.value,
        description: strController.pluginManagerDesStr.value,
        map: {},
        options: [
          MapOptions.OPEN_PLUGIN_MANAGER,
          MapOptions.LOAD_PLUGIN,
        ]),
    batteryOptimisation: ToggleSetting(
      name: strController.batteryOptimisationStr.value,
      description: strController.batteryOptimisationDesStr.value,
      value: false,
    ),
    enableAdditionalTrackers: ToggleSetting(
      name: strController.enableAdditionalTrackersStr.value,
      description: strController.enableAdditionalTrackersDesStr.value,
      value: true,
    ),
    enableZeroNetFilters: ToggleSetting(
      name: strController.enableZeroNetFiltersStr.value,
      description: strController.enableZeroNetFiltersDesStr.value,
      value: true,
    ),
    publicDataFolder: ToggleSetting(
      name: strController.publicDataFolderStr.value,
      description: strController.publicDataFolderDesStr.value,
      value: false,
    ),
    vibrateOnZeroNetStart: ToggleSetting(
      name: strController.vibrateOnZeroNetStartStr.value,
      description: strController.vibrateOnZeroNetStartDesStr.value,
      value: false,
    ),
    enableFullScreenOnWebView: ToggleSetting(
      name: strController.enableFullScreenOnWebViewStr.value,
      description: strController.enableFullScreenOnWebViewDesStr.value,
      value: false,
    ),
    autoStartZeroNet: ToggleSetting(
      name: strController.autoStartZeroNetStr.value,
      description: strController.autoStartZeroNetDesStr.value,
      value: true,
    ),
    autoStartZeroNetonBoot: ToggleSetting(
      name: strController.autoStartZeroNetonBootStr.value,
      description: strController.autoStartZeroNetonBootDesStr.value,
      value: false,
    ),
    debugZeroNet: ToggleSetting(
      name: strController.debugZeroNetStr.value,
      description: strController.debugZeroNetDesStr.value,
      value: false,
    ),
    enableZeroNetConsole: ToggleSetting(
      name: strController.enableZeroNetConsoleStr.value,
      description: strController.enableZeroNetConsoleDesStr.value,
      value: false,
    ),
    enableTorLog: ToggleSetting(
      name: strController.enableTorLogStr.value,
      description: strController.enableTorLogDesStr.value,
      value: false,
    ),
  };
}

enum MapOptions {
  CREATE_PROFILE,
  IMPORT_PROFILE,
  BACKUP_PROFILE,

  OPEN_PLUGIN_MANAGER,
  LOAD_PLUGIN,

  THEME_LIGHT,
  THEME_DARK,
  THEME_BLACK,
}

extension MapOptionExt on MapOptions {
  get description {
    switch (this) {
      case MapOptions.CREATE_PROFILE:
        return strController.createNewProfileStr.value;
        break;
      case MapOptions.IMPORT_PROFILE:
        return strController.importProfileStr.value;
        break;
      case MapOptions.BACKUP_PROFILE:
        return strController.backupProfileStr.value;
        break;
      case MapOptions.OPEN_PLUGIN_MANAGER:
        return strController.openPluginManagerStr.value;
        break;
      case MapOptions.LOAD_PLUGIN:
        return strController.loadPluginStr.value;
        break;
      case MapOptions.THEME_LIGHT:
        return 'Light';
        break;
      case MapOptions.THEME_DARK:
        return 'Dark';
        break;
      case MapOptions.THEME_BLACK:
        return 'Black';
        break;
    }
  }

  void onClick(BuildContext context) async {
    switch (this) {
      case MapOptions.CREATE_PROFILE:
        {
          if (isZeroNetUserDataExists()) {
            showDialogW(
              context: context,
              title: strController.existingProfileTitleStr.value,
              body: ProfileSwitcherUserNameEditText(),
              actionOk: Row(
                children: <Widget>[
                  TextButton(
                    child: Text(strController.createStr.value),
                    onPressed: () {
                      if (username.isNotEmpty) {
                        File file = File(getZeroNetUsersFilePath());
                        var f = file.renameSync(
                            getZeroNetDataDir().path + '/users-$username.json');
                        if (f.existsSync()) {
                          if (file.existsSync()) file.deleteSync();
                          Navigator.pop(context);
                          ZeroNet.instance.shutDown();
                          service.sendData({'cmd': 'runZeroNet'});
                        }
                        username = '';
                        uiStore.updateCurrentAppRoute(AppRoute.Settings);
                        var value2 = uiStore.reload.value;
                        uiStore.updateReload(value2 + 1);
                      } else {
                        validUsername = false;
                        // _reload();
                      }
                    },
                  ),
                  TextButton(
                    child: Text(strController.backupStr.value),
                    onPressed: () => backUpUserJsonFile(context),
                  ),
                ],
              ),
            );
          } else
            zeronetNotInit(context);
        }
        break;
      case MapOptions.IMPORT_PROFILE:
        {
          var file = await getUserJsonFile();
          if (file != null && file.path.endsWith('users.json')) {
            var isSameUser = file.existsSync()
                ? getZeroNetUsersFilePath() == file.path
                : false;
            showDialogW(
              context: context,
              title: strController.restoreProfileTitleStr.value,
              body: Text(
                '${strController.restoreProfileDesStr.value}'
                '$filePath'
                '\n\n${isSameUser ? '${strController.restoreProfileDes1Str.value}' : ''}',
              ),
              actionOk: Row(
                children: <Widget>[
                  TextButton(
                    onPressed: isSameUser
                        ? null
                        : () async {
                            File f = File(getZeroNetUsersFilePath());
                            printOut(f.path);
                            if (!isSameUser) {
                              if (f.existsSync()) f.deleteSync();
                              f.createSync();
                              f.writeAsStringSync(file.readAsStringSync());
                              // _reload();
                              try {
                                ZeroNet.instance.shutDown();
                              } catch (e) {
                                printOut(e);
                              }
                              service.sendData({'cmd': 'runZeroNet'});
                              Navigator.pop(context);
                            }
                          },
                    child: Text(
                      strController.restoreStr.value,
                    ),
                  ),
                  TextButton(
                    child: Text(strController.backupStr.value),
                    onPressed: () => backUpUserJsonFile(context),
                  ),
                ],
              ),
            );
          }
        }
        break;
      case MapOptions.BACKUP_PROFILE:
        backUpUserJsonFile(context);
        break;
      case MapOptions.LOAD_PLUGIN:
        {
          showDialogW(
            context: context,
            title: strController.zninstallAPluginTitleStr.value,
            body: Text(
              strController.zninstallAPluginDesStr.value,
              style: TextStyle(
                color: uiStore.currentTheme.value.primaryTextColor,
              ),
            ),
            actionOk: TextButton(
              onPressed: () async {
                var file = await getPluginZipFile();
                if (file != null) {
                  Navigator.pop(context);
                  installPluginDialog(file, context);
                }
              },
              child: Text(strController.installStr.value),
            ),
          );
        }
        break;
      case MapOptions.OPEN_PLUGIN_MANAGER:
        showDialogW(
          context: context,
          title: pluginManager,
          body: PluginManager(),
          actionOk: TextButton(
            onPressed: () {
              ZeroNet.instance.shutDown();
              service.sendData({'cmd': 'runZeroNet'});
              Navigator.pop(context);
            },
            child: Text(strController.restartStr.value),
          ),
        );
        break;
      case MapOptions.THEME_LIGHT:
        uiStore.setTheme(AppTheme.Light);
        var setting = (varStore.settings[themeSwitcher] as MapSetting)
          ..map['selected'] = 'Light';
        varStore.updateSetting(setting);
        saveSettings(varStore.settings);
        break;
      case MapOptions.THEME_DARK:
        uiStore.setTheme(AppTheme.Dark);
        var setting = (varStore.settings[themeSwitcher] as MapSetting)
          ..map['selected'] = 'Dark';
        varStore.updateSetting(setting);
        saveSettings(varStore.settings);
        break;
      case MapOptions.THEME_BLACK:
        uiStore.setTheme(AppTheme.Black);
        var setting = (varStore.settings[themeSwitcher] as MapSetting)
          ..map['selected'] = 'Black';
        varStore.updateSetting(setting);
        saveSettings(varStore.settings);
        break;
      default:
    }
  }
}

enum Feature {
  SITE_PAUSE_RESUME,
  SITE_DELETE,
  IN_APP_UPDATES,
}
