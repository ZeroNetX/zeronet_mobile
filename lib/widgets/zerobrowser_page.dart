import '../imports.dart';

final flutterWebViewPlugin = FlutterWebviewPlugin();

// ignore: must_be_immutable
class ZeroBrowser extends StatelessWidget {
  Color browserBgColor = uiStore.currentTheme.value.browserBgColor;
  setTheme() {
    Brightness? brightness;
    switch (zeroBrowserTheme) {
      case 'dark':
        brightness = Brightness.light;
        if (uiStore.currentTheme.value == AppTheme.Light)
          browserBgColor = Color(0xFF22272d);
        break;
      case 'light':
        brightness = Brightness.dark;
        if (uiStore.currentTheme.value == AppTheme.Dark ||
            uiStore.currentTheme.value == AppTheme.Black)
          browserBgColor = Color(0xFFEDF2F5);
        break;
      default:
    }
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: brightness,
        systemNavigationBarIconBrightness: brightness,
        statusBarBrightness: brightness,
        statusBarColor: browserBgColor,
        systemNavigationBarColor: browserBgColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setTheme();
    bool fullScreenWebView =
        (varStore.settings[enableFullScreenOnWebView] as ToggleSetting?)
                ?.value ??
            false;
    if (fullScreenWebView)
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    // ignore: prefer_collection_literals
    final Set<JavascriptChannel> jsChannels = [
      JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          printOut(message.message);
        },
      ),
    ].toSet();
    flutterWebViewPlugin.onUrlChanged.listen((newUrl) {
      browserUrl = newUrl;
      if (browserUrl.startsWith('https://blockchain.info/address/') ||
          browserUrl.startsWith('https://www.blockchain.com/btc/address/')) {
        uiStore.updateCurrentAppRoute(AppRoute.AboutPage);
        fromBrowser = true;
      }
    });
    return WillPopScope(
      onWillPop: () {
        if (launchUrl!.isNotEmpty) {
          return Future.value(true);
        } else {
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: [
              SystemUiOverlay.top,
              SystemUiOverlay.bottom,
            ],
          );
          loadUsersFromFileSystem();
          setZeroBrowserThemeValues();
          setSystemUiTheme();
          uiStore.updateCurrentAppRoute(AppRoute.Home);
          return Future.value(false);
        }
      },
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Theme(
              data: zeroBrowserTheme == 'dark'
                  ? ThemeData.dark()
                  : ThemeData.light(),
              child: WebviewScaffold(
                url: browserUrl,
                javascriptChannels: jsChannels,
                mediaPlaybackRequiresUserGesture: false,
                appCacheEnabled: true,
                withZoom: true,
                useWideViewPort: true,
                withLocalStorage: true,
                hidden: true,
                initialChild: Container(
                  color: zeroBrowserTheme == 'dark'
                      ? Colors.blueGrey[900]
                      : Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                        Text(
                          '${strController.loadingStr.value}.....',
                          style: TextStyle(
                            color: zeroBrowserTheme == 'light'
                                ? Colors.blueGrey[900]
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  color: browserBgColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.home),
                        color: uiStore.currentTheme.value.browserIconColor,
                        onPressed: () {
                          SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.manual,
                            overlays: [
                              SystemUiOverlay.top,
                              SystemUiOverlay.bottom,
                            ],
                          );
                          SystemChrome.setSystemUIOverlayStyle(
                            SystemUiOverlayStyle(
                              statusBarColor: Colors.transparent,
                              systemNavigationBarColor: Colors.white,
                              statusBarIconBrightness: Brightness.dark,
                              systemNavigationBarIconBrightness:
                                  Brightness.dark,
                            ),
                          );
                          uiStore.updateCurrentAppRoute(AppRoute.Home);
                        },
                      ),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share),
                        color: uiStore.currentTheme.value.browserIconColor,
                        onPressed: () => Share.share(browserUrl),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: uiStore.currentTheme.value.browserIconColor,
                        onPressed: () {
                          flutterWebViewPlugin.goBack();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        color: uiStore.currentTheme.value.browserIconColor,
                        onPressed: () {
                          flutterWebViewPlugin.goForward();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.autorenew),
                        color: uiStore.currentTheme.value.browserIconColor,
                        onPressed: () {
                          flutterWebViewPlugin.reload();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
