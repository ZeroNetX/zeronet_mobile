import 'dart:async';

import 'package:flutter/material.dart';
import 'common.dart';
import 'widgets.dart';

//Remainder: Removed Half baked x86 bins, add them when we support x86 platform
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
}
