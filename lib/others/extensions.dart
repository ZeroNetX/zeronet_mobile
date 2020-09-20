import 'dart:io';

extension FileSystemExtension on FileSystemEntity {
  String name() => this.path.replaceFirst(this.parent.path + '/', '');
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => str.inCaps).join(" ");
}

extension DynamicExt on dynamic {
  int toInt() {
    if (this is num) {
      if (this is double) return this.toInt();
      if (this is int) return this;
    }
    return -1;
  }
}
