import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'common.dart';
import 'widgets.dart';

Future main() async {
  init();
  await FlutterDownloader.initialize();
  runApp(MyApp());
  FlutterDownloader.registerCallback(handleDownloads);
}
