import 'imports.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  if (kEnableInAppPurchases) {
    InAppPurchaseConnection.enablePendingPurchases();
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    purchaseUpdates.listen((purchases) => listenToPurchaseUpdated(purchases));
  }
  launchUrl = await launchZiteUrl();
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
              scaffoldState = Scaffold.of(context);
              if (firstTime) {
                SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                uiStore.updateCurrentAppRoute(AppRoute.Settings);
                makeExecHelper();
              }
              if (uiStore.zeroNetStatus == ZeroNetStatus.NOT_RUNNING &&
                  !manuallyStoppedZeroNet) {
                checkInitStatus();
              }
              if (launchUrl.isNotEmpty) {
                browserUrl = (zeroNetUrl.isEmpty
                        ? "http://127.0.0.1:43110/"
                        : zeroNetUrl) +
                    launchUrl;
                if (uiStore.zeroNetStatus == ZeroNetStatus.RUNNING) {
                  uiStore.updateCurrentAppRoute(AppRoute.ZeroBrowser);
                } else
                  uiStore.updateCurrentAppRoute(AppRoute.ShortcutLoadingPage);
              }
              return Observer(
                builder: (ctx) {
                  switch (uiStore.currentAppRoute) {
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
