import 'package:get/get.dart';
import 'imports.dart';

//TODO:Remainder: Removed Half baked x86 bins, add them when we support x86 platform
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  if (kEnableInAppPurchases) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    final Stream purchaseUpdates = InAppPurchase.instance.purchaseStream;
    purchaseUpdates.listen((purchases) => listenToPurchaseUpdated(purchases));
  }
  launchUrl = await launchZiteUrl();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            setSystemUiTheme();
            if (varStore.zeroNetInstalled.value) {
              if (firstTime) {
                SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
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
                browserUrl = (zeroNetUrl.isEmpty
                        ? "http://127.0.0.1:43110/"
                        : zeroNetUrl) +
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
                          uiStore.updateCurrentAppRoute(AppRoute.Home);
                          return Future.value(false);
                        },
                        child: AboutPage(),
                      );
                      break;
                    case AppRoute.Home:
                      getInAppPurchases();
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
        ),
      ),
    );
  }
}
