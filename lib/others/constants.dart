import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeronet/mobx/uistore.dart';
import 'package:zeronet/models/models.dart';
import 'package:zeronet/others/utils.dart';
import 'package:zeronet/others/zeronet_utils.dart';
import 'package:zeronet/widgets/common.dart';
import 'package:zeronet_ws/zeronet_ws.dart';

import 'common.dart';
import 'native.dart';

const String pkgName = 'in.canews.zeronet${kDebugMode ? '.debug' : ''}';
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
const String zeronetStartUpError = 'Startup error: ';
const String zeronetAlreadyRunningError =
    zeronetStartUpError + 'Can\'t open lock file';
const bool kEnableDynamicModules = !kDebugMode;

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

const String profileSwitcher = 'Profile Switcher';
const String profileSwitcherDes =
    'Create and Use different Profiles on ZeroNet';
const String debugZeroNet = 'Debug ZeroNet Code';
const String debugZeroNetDes =
    'Useful for Developers to find bugs and errors in the code.';
const String enableZeroNetConsole = 'Enable ZeroNet Console';
const String enableZeroNetConsoleDes =
    'Useful for Developers to see the exec of ZeroNet Python code';
const String pluginManager = 'Plugin Manager';
const String pluginManagerDes = 'Enable/Disable ZeroNet Plugins';
const String vibrateOnZeroNetStart = 'Vibrate on ZeroNet Start';
const String vibrateOnZeroNetStartDes = 'Vibrates Phone When ZeroNet Starts';
const String enableFullScreenOnWebView = 'FullScreen for ZeroNet Zites';
const String enableFullScreenOnWebViewDes =
    'This will Enable Full Screen for in app Webview of ZeroNet';
const String batteryOptimisation = 'Disable Battery Optimisation';
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

  static const initialSites = const {
    'ZeroHello': {
      'description': 'Say Hello to ZeroNet, a Dashboard to manage ' +
          'all your ZeroNet Z(S)ites, You can view feed of other zites like ' +
          'posts, comments of other users from ZeroTalk as well for your posts ' +
          'and Stats like Total Requests sent and received from other peers on ZeroNet. ' +
          'You can also pause, clone or favourite, delete Zites from single page.',
      'url': urlHello,
      'btcAddress': urlHello,
    },
    'ZeroNetMobile': {
      'description': 'Forum to report ZeroNet Mobile app issues. ' +
          'Want a new feature in the app, Request a Feature. ' +
          'Facing any Bugs while using the app ? ' +
          'Just report problem here, we will take care of it. ' +
          'Want to Discuss any topic about app development ? ' +
          'Just dive into to this Zite.',
      'url': urlZeroNetMob,
      'btcAddress': urlZeroNetMob,
    },
    'ZeroTalk': {
      'description': 'Need a forum to discuss something, ' +
          'we got covered you here. ZeroTalk fits your need, ' +
          'just post something to get opinion from others on Network. ' +
          'Have some queries ? don\'t hesitate to ask here.' +
          'Tired of Spam ? Who don\'t! You can mute individual users also.',
      'url': urlTalk,
      'btcAddress': btcUrlTalk,
    },
    'ZeroBlog': {
      'description': 'Want to Know Where ZeroNet is Going ? ' +
          'ZeroBlog gives you latest changes and improvements ' +
          'made to ZeroNet, including Bug Fixes, ' +
          'Speed Improvements of ZeroNet Core Software. ' +
          'Also Provides varies links to ZeroNet Protocol and ' +
          'how ZeroNet works underhood and much more things to know.',
      'url': urlBlog,
      'btcAddress': btcUrlBlog,
    },
    'ZeroMail': {
      'description': 'So you need a mail service, use ZeroMail, ' +
          'fully end-to-end encrypted mail service on ZeroNet, ' +
          'don\'t let others scanning your mailbox for their profits ' +
          'all your data is encrypted and can only opened by you. ' +
          'Your all mails are backedup, so you can stay calm for your data.',
      'url': urlMail,
      'btcAddress': btcUrlMail,
    },
    'ZeroMe': {
      'description': 'Social Network is everywhere, so we made one here too. ' +
          'Twitter like, Peer to Peer Social Networking in your hands without data-tracking, ' +
          'Follow others and post your thoughts, like, comment on others posts, it\'s that easy-peasy. ' +
          'Find Like minded people and increase your friend circle beyond the borders.',
      'url': urlMe,
      'btcAddress': btcUrlMe,
    },
    'ZeroSites': {
      'description': 'Want to know more sites on ZeroNet, ' +
          'visit ZeroSites, listing of community contributed sites under various ' +
          'categories like Blogs, Services, Forums, Chat, Video, Image, Guides, News and much more. ' +
          'You can even filter those lists with your preferred language ' +
          'to get more comprehensive list. Has a New Site to Show, Just Submit here.',
      'url': urlSites,
      'btcAddress': btcUrlSites,
    },
  };

  // 'ZeroName': '1Name2NXVi1RDPDgf5617UoW7xA6YrhM9F',

  static const String createProfile = 'Create'; // New Profile
  static const String importProfile = 'Import'; // Profile
  static const String backupProfile = 'Backup'; // Profile

  static const String openPluginManager = 'Open Plugin Manager';
  static const String loadPlugin = 'Load Custom Plugin';

  Map<String, Setting> defSettings = {
    profileSwitcher: MapSetting(
        name: profileSwitcher,
        description: profileSwitcherDes,
        map: {
          "selected": '',
          "all": [],
        },
        options: [
          MapOptions.CREATE_PROFILE,
          MapOptions.IMPORT_PROFILE,
          MapOptions.BACKUP_PROFILE,
        ]),
    pluginManager: MapSetting(
        name: pluginManager,
        description: pluginManagerDes,
        map: {},
        options: [
          MapOptions.OPEN_PLUGIN_MANAGER,
          MapOptions.LOAD_PLUGIN,
        ]),
    batteryOptimisation: ToggleSetting(
      name: batteryOptimisation,
      description: batteryOptimisationDes,
      value: false,
    ),
    publicDataFolder: ToggleSetting(
      name: publicDataFolder,
      description: publicDataFolderDes,
      value: false,
    ),
    vibrateOnZeroNetStart: ToggleSetting(
      name: vibrateOnZeroNetStart,
      description: vibrateOnZeroNetStartDes,
      value: false,
    ),
    enableFullScreenOnWebView: ToggleSetting(
      name: enableFullScreenOnWebView,
      description: enableFullScreenOnWebViewDes,
      value: false,
    ),
    autoStartZeroNet: ToggleSetting(
      name: autoStartZeroNet,
      description: autoStartZeroNetDes,
      value: true,
    ),
    autoStartZeroNetonBoot: ToggleSetting(
      name: autoStartZeroNetonBoot,
      description: autoStartZeroNetonBootDes,
      value: false,
    ),
    debugZeroNet: ToggleSetting(
      name: debugZeroNet,
      description: debugZeroNetDes,
      value: false,
    ),
    enableZeroNetConsole: ToggleSetting(
      name: enableZeroNetConsole,
      description: enableZeroNetConsoleDes,
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
}

extension MapOptionExt on MapOptions {
  get description {
    switch (this) {
      case MapOptions.CREATE_PROFILE:
        return 'Create New Profile';
        break;
      case MapOptions.IMPORT_PROFILE:
        return 'Import Profile';
        break;
      case MapOptions.BACKUP_PROFILE:
        return 'Backup Profile';
        break;
      case MapOptions.OPEN_PLUGIN_MANAGER:
        return 'Open Plugin Manager';
        break;
      case MapOptions.LOAD_PLUGIN:
        return 'Load Plugin';
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
              title: 'Provide A Name for Existing Profile',
              body: ProfileSwitcherUserNameEditText(),
              actionOk: Row(
                children: <Widget>[
                  FlatButton(
                    child: Text('Create'),
                    onPressed: () {
                      if (username.isNotEmpty) {
                        File file = File(getZeroNetUsersFilePath());
                        var f = file.renameSync(
                            getZeroNetDataDir().path + '/users-$username.json');
                        if (f.existsSync()) {
                          if (file.existsSync()) file.deleteSync();
                          Navigator.pop(context);
                          ZeroNet.instance.shutDown();
                          runZeroNet();
                        }
                        username = '';
                        uiStore.updateCurrentAppRoute(AppRoute.Settings);
                        uiStore.updateReload(uiStore.reload++);
                      } else {
                        validUsername = false;
                        // _reload();
                      }
                    },
                  ),
                  FlatButton(
                    child: Text('Backup'),
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
              title: 'Restore Profile ?',
              body: Text(
                'this will delete the existing profile, '
                'backup existing profile using backup button below\n\n'
                'Selected Userfile : \n'
                '$filePath'
                '\n\n${isSameUser ? 'You can only select users.json file, outside zeronet data folder' : ''}',
              ),
              actionOk: Row(
                children: <Widget>[
                  FlatButton(
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
                              runZeroNet();
                              Navigator.pop(context);
                            }
                          },
                    child: Text(
                      'Restore',
                    ),
                  ),
                  FlatButton(
                    child: Text('Backup'),
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
            title: 'Install a Plugin',
            body: Text('This will load plugin to your ZeroNet repo, '
                '\nWarning : Loading Unknown/Untrusted plugins may compromise ZeroNet Installation.'),
            actionOk: FlatButton(
              onPressed: () async {
                var file = await getPluginZipFile();
                if (file != null) {
                  Navigator.pop(context);
                  installPluginDialog(file, context);
                }
              },
              child: Text('Install'),
            ),
          );
        }
        break;
      case MapOptions.OPEN_PLUGIN_MANAGER:
        showDialogW(
          context: context,
          title: pluginManager,
          body: PluginManager(),
          actionOk: FlatButton(
            onPressed: () {
              ZeroNet.instance.shutDown();
              runZeroNet();
              Navigator.pop(context);
            },
            child: Text('Restart'),
          ),
        );
        break;
      default:
    }
  }
}
