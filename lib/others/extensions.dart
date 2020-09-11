import 'dart:io';

extension FileSystemExtension on FileSystemEntity {
  String name() => this.path.replaceFirst(this.parent.path + '/', '');
}
