import '../imports.dart';

// ignore: must_be_immutable
class ZeroBrowser extends StatelessWidget {
  Color browserBgColor = uiStore.currentTheme.value.browserBgColor;
  static final flutterWebViewPlugin = FlutterWebviewPlugin();
  setTheme() {
    Brightness brightness;
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
              data: ThemeData.dark(),
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
                  color:
                      // zeroBrowserTheme == 'dark'
                      //     ? uiStore.currentTheme.value
                      //         .
                      browserBgColor, //Colors.blueGrey[900]
                  // : Colors.white,
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
            ),
          ],
        ),
      ),
    );
  }
}
