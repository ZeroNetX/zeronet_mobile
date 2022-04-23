import 'package:zeronet/imports.dart';

extension FileSystemExtension on FileSystemEntity {
  String get name => this.path.replaceFirst(this.parent.path + '/', '');
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => str.inCaps).join(" ");
  String get zeroNetDataPath => getZeroNetDataDir().path + '/' + this + '/';
}

extension DynamicExt on dynamic {
  int? toInt() {
    if (this is num) {
      if (this is double) return this.toInt();
      if (this is int) return this;
    }
    return -1;
  }
}

extension PlatformExt on Platform {
  static get isDesktop =>
      (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  static get isMobile => (Platform.isAndroid || Platform.isIOS);

  static get isSupportedDesktop => (Platform.isWindows);
  static get isSupportedMobile => (Platform.isAndroid);

  static get isSupported => (isSupportedDesktop || isSupportedMobile);
}
