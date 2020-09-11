import 'dart:async';

import 'package:flutter/material.dart';
import 'others/common.dart';
import 'widgets/my_app.dart';

//TODO:Remainder: Removed Half baked x86 bins, add them when we support x86 platform
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
}
