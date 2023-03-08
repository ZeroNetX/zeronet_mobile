import '../imports.dart';

// export 'constants/platform_constants.dart';

/// [Platform] specific implementation of PathSeparator.
final sep = Platform.pathSeparator;
final exeDir = Directory(Platform.resolvedExecutable).parent.path;
final String pkgName = Directory(
  Platform.isAndroid
      ? 'in.canews.zeronetmobile${kDebugMode ? '.debug' : ''}'
      : exeDir + sep + 'data' + sep + 'app',
).path;
final String dataDir = Directory(
  Platform.isAndroid
      ? "${sep}data${sep}data${sep}$pkgName${sep}files"
      : pkgName,
).path;
final String zeroNetDir =
    dataDir + sep + (Platform.isWindows ? 'ZeroNet-win' : 'ZeroNet-py3');
final String bin = '$dataDir${sep}usr${sep}bin';
final String python = '$bin${sep}python';
final String libDir = '$dataDir${sep}usr${sep}lib';
final String libDir64 = '$dataDir${sep}usr${sep}lib64';
final String zeronetDir = zeroNetDir;
final String zeronet = '$zeronetDir${sep}zeronet.py';
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
