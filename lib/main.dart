import 'package:zeronet/dashboard/app.dart';
import 'dashboard/imports.dart';

import 'others/common.dart' as common;

import 'imports.dart' hide init;

//TODO:Remainder: Removed Half baked x86 bins, add them when we support x86 platform
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await common.init();
  runApp(MyApp());
  if (PlatformExt.isDesktop) {
    doWhenWindowReady(() {
      final win = appWindow;
      // const initialSize = Size(600, 450);
      // win.minSize = initialSize;
      // win.size = initialSize;
      // win.position = const Offset(250, 250);
      win.title = "ZeroNetX";
      win.show();
    });
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (PlatformExt.isDesktop) initSystemTray();
    return GetMaterialApp(
      title: 'ZeroNet Mobile',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Obx(
          () {
            var child = (PlatformExt.isDesktop)
                ? Obx(
                    () => Column(
                      children: [
                        WindowTitleBarBox(
                          child: Container(
                            color: siteUiController
                                .currentTheme.value.titleBarColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: MoveWindow(
                                    child: Container(
                                      color: siteUiController
                                          .currentTheme.value.primaryColor,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    MinimizeWindowButton(
                                      onPressed: () {
                                        appWindow.minimize();
                                        uiStore.isWindowVisible.value = false;
                                      },
                                      colors: WindowButtonColors(
                                        normal: siteUiController
                                            .currentTheme.value.cardBgColor,
                                        mouseOver: Colors.blueAccent,
                                        mouseDown: Colors.blue,
                                      ),
                                    ),
                                    MaximizeWindowButton(
                                      onPressed: () {
                                        appWindow.maximize();
                                        uiStore.isWindowVisible.value = true;
                                      },
                                      colors: WindowButtonColors(
                                        normal: siteUiController
                                            .currentTheme.value.cardBgColor,
                                        mouseOver: Colors.greenAccent,
                                        mouseDown: Colors.green,
                                      ),
                                    ),
                                    CloseWindowButton(
                                      onPressed: () {
                                        appWindow.hide();
                                        uiStore.isWindowVisible.value = false;
                                      },
                                      colors: WindowButtonColors(
                                        normal: siteUiController
                                            .currentTheme.value.cardBgColor,
                                        mouseOver: Colors.redAccent,
                                        mouseDown: Color(0xFFF44336),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: appContent()),
                      ],
                    ),
                  )
                : appContent();
            if (siteUiController.currentTheme.value == AppTheme.Light) {
              return Theme(data: ThemeData.light(), child: child);
            } else {
              return Theme(data: ThemeData.dark(), child: child);
            }
          },
        ),
      ),
    );
  }

  Obx appContent() {
    return Obx(
      () {
        setSystemUiTheme();
        if (varStore.zeroNetInstalled.value) {
          return DashboardApp();
        } else
          return Loading();
      },
    );
  }
}
