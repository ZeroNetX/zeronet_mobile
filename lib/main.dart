import 'imports.dart';

//TODO:Remainder: Removed Half baked x86 bins, add them when we support x86 platform
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
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
        body: (PlatformExt.isDesktop)
            ? Obx(
                () => Column(
                  children: [
                    WindowTitleBarBox(
                      child: Container(
                        color: uiStore.currentTheme.value.titleBarColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: MoveWindow(
                                child: Container(
                                  color:
                                      uiStore.currentTheme.value.primaryColor,
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
                                    normal:
                                        uiStore.currentTheme.value.cardBgColor,
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
                                    normal:
                                        uiStore.currentTheme.value.cardBgColor,
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
                                    normal:
                                        uiStore.currentTheme.value.cardBgColor,
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
            : appContent(),
      ),
    );
  }

  Obx appContent() {
    return Obx(
      () {
        setSystemUiTheme();
        if (varStore.zeroNetInstalled.value) {
          if (firstTime) {
            SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual,
              overlays: [
                SystemUiOverlay.top,
                SystemUiOverlay.bottom,
              ],
            );
            activateFilters();
            uiStore.updateCurrentAppRoute(AppRoute.Settings);
            if (!isExecPermitted)
              makeExecHelper().then(
                (value) => isExecPermitted = value,
              );
            if (zeroNetNativeDir.isNotEmpty) saveDataFile();
            // createTorDataDir();
            firstTime = false;
          }
          if (uiStore.zeroNetStatus.value == ZeroNetStatus.NOT_RUNNING &&
              !manuallyStoppedZeroNet) {
            checkInitStatus();
          }
          if (launchUrl.isNotEmpty) {
            browserUrl =
                (zeroNetUrl.isEmpty ? "http://127.0.0.1:43110/" : zeroNetUrl) +
                    launchUrl;
            if (uiStore.zeroNetStatus.value == ZeroNetStatus.RUNNING) {
              uiStore.updateCurrentAppRoute(AppRoute.ZeroBrowser);
            } else
              uiStore.updateCurrentAppRoute(AppRoute.ShortcutLoadingPage);
          }
          return Obx(
            () {
              setSystemUiTheme();
              switch (uiStore.currentAppRoute.value) {
                case AppRoute.AboutPage:
                  return WillPopScope(
                    onWillPop: () {
                      if (fromBrowser) {
                        fromBrowser = false;
                        flutterWebViewPlugin.canGoBack().then(
                              (value) =>
                                  value ? flutterWebViewPlugin.goBack() : null,
                            );
                        uiStore.updateCurrentAppRoute(AppRoute.ZeroBrowser);
                      } else
                        uiStore.updateCurrentAppRoute(AppRoute.Home);
                      return Future.value(false);
                    },
                    child: AboutPage(),
                  );
                  break;
                case AppRoute.Home:
                  if (PlatformExt.isMobile) getInAppPurchases();
                  return HomePage();
                  break;
                case AppRoute.Settings:
                  return WillPopScope(
                    onWillPop: () {
                      uiStore.updateCurrentAppRoute(AppRoute.Home);
                      return Future.value(false);
                    },
                    child: SettingsPage(),
                  );
                  break;
                case AppRoute.ShortcutLoadingPage:
                  return ShortcutLoadingPage();
                  break;
                case AppRoute.ZeroBrowser:
                  return ZeroBrowser();
                  break;
                case AppRoute.LogPage:
                  return WillPopScope(
                    onWillPop: () {
                      uiStore.updateCurrentAppRoute(AppRoute.Home);
                      return Future.value(false);
                    },
                    child: ZeroNetLogPage(),
                  );
                  break;
                default:
                  return Container();
              }
            },
          );
        } else
          return Loading();
      },
    );
  }
}
