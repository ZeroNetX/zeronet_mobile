import '../imports.dart';

class ZeroBrowser extends StatelessWidget {
  static final flutterWebViewPlugin = FlutterWebviewPlugin();
  setTheme() {
    switch (zeroBrowserTheme) {
      case 'dark':
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
            statusBarColor: uiStore
                .currentTheme.value.browserBgColor, //Colors.blueGrey[900], //
            systemNavigationBarColor: uiStore
                .currentTheme.value.browserBgColor, //Colors.blueGrey[900], //
          ),
        );
        break;
      case 'light':
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.white,
          ),
        );
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    setTheme();
    bool fullScreenWebView =
        (varStore.settings[enableFullScreenOnWebView] as ToggleSetting)?.value;
    if (fullScreenWebView) SystemChrome.setEnabledSystemUIOverlays([]);
    // ignore: prefer_collection_literals
    final Set<JavascriptChannel> jsChannels = [
      JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          printOut(message.message);
        },
      ),
    ].toSet();
    flutterWebViewPlugin.onUrlChanged.listen((newUrl) => browserUrl = newUrl);
    return WillPopScope(
      onWillPop: () {
        if (launchUrl.isNotEmpty) {
          return Future.value(true);
        } else {
          SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
          setSystemUiTheme();
          uiStore.updateCurrentAppRoute(AppRoute.Home);
          return Future.value(false);
        }
      },
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            WebviewScaffold(
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
                        'Loading.....',
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
                color: zeroBrowserTheme == 'dark'
                    ? uiStore.currentTheme.value
                        .browserBgColor //Colors.blueGrey[900]
                    : Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.home),
                      color: zeroBrowserTheme == 'light'
                          ? uiStore.currentTheme.value.browserBgColor
                          : Colors.white,
                      onPressed: () {
                        SystemChrome.setEnabledSystemUIOverlays(
                            SystemUiOverlay.values);
                        SystemChrome.setSystemUIOverlayStyle(
                          SystemUiOverlayStyle(
                            statusBarColor: Colors.transparent,
                            systemNavigationBarColor: Colors.white,
                            statusBarIconBrightness: Brightness.dark,
                            systemNavigationBarIconBrightness: Brightness.dark,
                          ),
                        );
                        uiStore.updateCurrentAppRoute(AppRoute.Home);
                      },
                    ),
                    Spacer(),
                    IconButton(
                      icon: const Icon(Icons.share),
                      color: zeroBrowserTheme == 'light'
                          ? uiStore.currentTheme.value.browserBgColor
                          : Colors.white,
                      onPressed: () => Share.share(browserUrl),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: zeroBrowserTheme == 'light'
                          ? uiStore.currentTheme.value.browserBgColor
                          : Colors.white,
                      onPressed: () {
                        flutterWebViewPlugin.goBack();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      color: zeroBrowserTheme == 'light'
                          ? uiStore.currentTheme.value.browserBgColor
                          : Colors.white,
                      onPressed: () {
                        flutterWebViewPlugin.goForward();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.autorenew),
                      color: zeroBrowserTheme == 'light'
                          ? uiStore.currentTheme.value.browserBgColor
                          : Colors.white,
                      onPressed: () {
                        flutterWebViewPlugin.reload();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
