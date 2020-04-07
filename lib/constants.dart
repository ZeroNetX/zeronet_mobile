import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
