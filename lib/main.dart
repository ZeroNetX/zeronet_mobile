import 'dart:async';

import 'package:flutter/material.dart';
import 'common.dart';
import 'widgets.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
}
