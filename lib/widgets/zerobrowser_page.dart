import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';
import 'package:zeronet/mobx/uistore.dart';
import 'package:zeronet/mobx/varstore.dart';
import 'package:zeronet/models/models.dart';
import 'package:zeronet/others/common.dart';
import 'package:zeronet/others/constants.dart';
import 'package:zeronet/others/utils.dart';

class ZeroBrowser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    final flutterWebViewPlugin = FlutterWebviewPlugin();
    flutterWebViewPlugin.onUrlChanged.listen((newUrl) => browserUrl = newUrl);
    return WillPopScope(
      onWillPop: () {
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        if (launchUrl.isNotEmpty) {
          return Future.value(true);
        } else {
          uiStore.updateCurrentAppRoute(AppRoute.Home);
          return Future.value(false);
        }
      },
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: fullScreenWebView ? 0.0 : 0.0), //80.0
              child: WebviewScaffold(
                url: browserUrl,
                javascriptChannels: jsChannels,
                mediaPlaybackRequiresUserGesture: false,
                appCacheEnabled: true,
                // appBar: appBar(),
                withZoom: true,
                useWideViewPort: true,
                withLocalStorage: true,
                hidden: true,
                initialChild: Container(
                  // color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                        Text('Loading.....'),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.home),
                        onPressed: () {
                          SystemChrome.setEnabledSystemUIOverlays(
                              SystemUiOverlay.values);
                          uiStore.updateCurrentAppRoute(AppRoute.Home);
                        },
                      ),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () => Share.share(browserUrl),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          flutterWebViewPlugin.goBack();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          flutterWebViewPlugin.goForward();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.autorenew),
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
