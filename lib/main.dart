import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:zeronet/mobx/uistore.dart';
import 'package:zeronet/mobx/varstore.dart';
import 'package:zeronet/widgets/home_page.dart';
import 'package:zeronet/widgets/loading_page.dart';
import 'package:zeronet/widgets/log_page.dart';
import 'package:zeronet/widgets/settings_page.dart';
import 'package:zeronet/widgets/zerobrowser_page.dart';
import 'others/common.dart';
import 'others/utils.dart';

//TODO:Remainder: Removed Half baked x86 bins, add them when we support x86 platform
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      title: 'ZeroNet Mobile',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Observer(
          builder: (context) {
            if (varStore.zeroNetInstalled) {
              if (firstTime) {
                uiStore.updateCurrentAppRoute(AppRoute.Settings);
                makeExecHelper();
              }
              return Observer(
                builder: (ctx) {
                  switch (uiStore.currentAppRoute) {
                    case AppRoute.Home:
                      return HomePage();
                      break;
                    case AppRoute.Settings:
                      return SettingsPage();
                      break;
                    case AppRoute.ZeroBrowser:
                      return ZeroBrowser();
                      break;
                    case AppRoute.LogPage:
                      return ZeroNetLogPage();
                      break;
                    default:
                      return Container();
                  }
                },
              );
            }
            return Loading();
          },
        ),
      ),
    );
  }
}
