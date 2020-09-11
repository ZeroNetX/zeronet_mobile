import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';
import 'package:zeronet_ws/zeronet_ws.dart';

import '../others/common.dart';
import '../others/constants.dart';
import '../models/models.dart';
import '../mobx/varstore.dart';
import '../others/native.dart';
import '../others/utils.dart';
import '../others/zeronet_utils.dart';
import 'settings_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showLog = false;

  @override
  initState() {
    checkInitStatus();
    if (firstTime) {
      viewSettings = true;
      makeExecHelper();
    }
    flutterWebViewPlugin.onUrlChanged.listen((newUrl) => browserUrl = newUrl);
    super.initState();
  }

  _reload() => this.mounted ? setState(() {}) : null;

  checkInitStatus() async {
    try {
      String url = defZeroNetUrl + Utils.initialSites['ZeroMobile']['url'];
      String key = await ZeroNet.instance.getWrapperKey(url);
      zeroNetUrl = defZeroNetUrl;
      varStore.zeroNetWrapperKey = key;
      varStore.setZeroNetStatus('Running');
      ZeroNet.instance.connect(
        zeroNetIPwithPort(defZeroNetUrl),
        Utils.urlHello,
      );
      showZeroNetRunningNotification(enableVibration: false);
      testUrl();
    } catch (e) {
      if (!firstTime &&
          (varStore.settings[autoStartZeroNet] as ToggleSetting).value == true)
        runZeroNet();
      if (e is OSError) {
        if (e.errorCode == 111) {
          printToConsole('Zeronet Not Running');
        }
      }
    }
  }

  bool viewBrowser = false;
  bool viewSettings = false;

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

  void setAppBarTitle() {
    if (!viewBrowser) {
      if (showLog)
        varStore.setZeroNetAppbarStatus('ZeroNet Log');
      else if (viewSettings)
        varStore.setZeroNetAppbarStatus('App Settings');
      else
        varStore.setZeroNetAppbarStatus('ZeroNet Mobile');
    } else
      varStore.setZeroNetAppbarStatus('ZeroNet Browser');
  }

  AppBar appBar() {
    return AppBar(
      title: Observer(
        builder: (context) {
          return Text(varStore.zeroNetAppbarStatus);
        },
      ),
      actions: <Widget>[
        if (!viewBrowser && !viewSettings)
          IconButton(
            icon: Icon(Icons.settings_applications),
            onPressed: () {
              viewSettings = !viewSettings;
              setAppBarTitle();
              _reload();
            },
          ),
        if ((varStore.settings[enableZeroNetConsole] as ToggleSetting).value)
          if (!viewBrowser && !viewSettings)
            IconButton(
              icon: Icon(Icons.content_paste),
              onPressed: () {
                showLog = !showLog;
                setAppBarTitle();
                _reload();
              },
            ),
        if (!viewBrowser && !viewSettings)
          IconButton(
            icon: Icon(Icons.open_in_browser),
            onPressed: () {
              viewBrowser = !viewBrowser;
              setAppBarTitle();
              _reload();
            },
          ),
        if (viewBrowser || viewSettings)
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              if (viewBrowser) {
                viewBrowser = !viewBrowser;
              } else {
                viewSettings = !viewSettings;
              }
              flutterWebViewPlugin.close();
              setAppBarTitle();
              _reload();
            },
          ),
      ],
    );
  }

  Widget webView() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 0.0), //80.0
          child: WebviewScaffold(
            url: browserUrl,
            javascriptChannels: jsChannels,
            mediaPlaybackRequiresUserGesture: false,
            appCacheEnabled: true,
            appBar: appBar(),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    if ((varStore.settings[enableFullScreenOnWebView] as ToggleSetting)
            ?.value ==
        true) {
      if (viewBrowser)
        SystemChrome.setEnabledSystemUIOverlays([]);
      else
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    } else
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return viewBrowser
        ? WillPopScope(
            onWillPop: () {
              viewBrowser = false;
              _reload();
              return Future.value(false);
            },
            child: webView(),
          )
        : Scaffold(
            appBar: appBar(),
            body: viewSettings
                ? SettingsPage()
                : SingleChildScrollView(
                    child: showLog
                        ? Observer(
                            builder: (_) => Text(varStore.zeroNetLog),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text(
                                      'Status',
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Observer(
                                      builder: (_) {
                                        bool isRunning =
                                            varStore.zeroNetStatus == 'Running';
                                        if (isRunning)
                                          ZeroNet.instance.connect(
                                            zeroNetIPwithPort(zeroNetUrl),
                                            Utils.urlHello,
                                          );
                                        return Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                6.0,
                                              ),
                                              child: Chip(
                                                backgroundColor: isRunning
                                                    ? Colors.greenAccent
                                                    : varStore.zeroNetStatus ==
                                                            'Not Running'
                                                        ? Colors.grey
                                                        : Colors.orange,
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                label: Text(
                                                  varStore.zeroNetStatus,
                                                ),
                                              ),
                                            ),
                                            if (isRunning)
                                              GestureDetector(
                                                child: const Padding(
                                                  padding: const EdgeInsets.all(
                                                    4.0,
                                                  ),
                                                  child: Chip(
                                                    backgroundColor: Colors.red,
                                                    padding:
                                                        const EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    label: const Text(
                                                      'Stop',
                                                    ),
                                                  ),
                                                ),
                                                onTap: shutDownZeronet,
                                              ),
                                            if (isRunning)
                                              GestureDetector(
                                                child: const Padding(
                                                  padding: const EdgeInsets.all(
                                                    4.0,
                                                  ),
                                                  child: Chip(
                                                    backgroundColor:
                                                        Colors.blueAccent,
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    label: const Text(
                                                      'More Info',
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  ZeroNet.instance.siteInfo(
                                                      callback: (msg) {
                                                    //TODO: Show Info in List Form.
                                                    showDialogC(
                                                      context: context,
                                                      title: 'ZeroNetInfo',
                                                      body: msg,
                                                    );
                                                  });
                                                },
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Observer(
                                builder: (context) {
                                  if (varStore.zeroNetStatus == 'Not Running')
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                          'Hint : ZeroNet is Not Running click on Play Button at the Bottom'),
                                    );
                                  return Container();
                                },
                              ),
                              PopularZeroNetSites(
                                callback: () {
                                  viewBrowser = true;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                  ),
            floatingActionButton: (viewSettings)
                ? null
                : FloatingActionButton(
                    child: Observer(
                      builder: (c) {
                        if (varStore.zeroNetStatus == 'Not Running')
                          return Icon(Icons.play_arrow);
                        return Icon(Icons.stop);
                      },
                    ),
                    onPressed: (varStore.zeroNetStatus == 'Not Running')
                        ? runZeroNet
                        : shutDownZeronet,
                  ),
          );
  }
}

class PopularZeroNetSites extends StatelessWidget {
  final VoidCallback callback;
  const PopularZeroNetSites({
    Key key,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> zeroSites = [];
    for (var key in Utils.initialSites.keys) {
      var name = key;
      var description = Utils.initialSites[key]['description'];
      var url = Utils.initialSites[key]['url'];
      var i = Utils.initialSites.keys.toList().indexOf(key);
      zeroSites.add(
        Container(
          height: 185,
          width: 185,
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors[i],
                colors[i + 1],
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        left: 15.0,
                      ),
                      child: AutoSizeText(
                        name,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                      ),
                      child: AutoSizeText(
                        description,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                    right: 12.0,
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Observer(builder: (context) {
                      return OutlineButton(
                        borderSide: BorderSide(color: Colors.white),
                        child: Text(
                          'Open',
                          style: TextStyle(
                            color: (varStore.zeroNetStatus == 'Running')
                                ? Colors.white
                                : Theme.of(context).disabledColor,
                          ),
                        ),
                        onPressed: (varStore.zeroNetStatus == 'Running')
                            ? () {
                                if (varStore.zeroNetStatus == 'Running') {
                                  browserUrl = zeroNetUrl + url;
                                  callback();
                                }
                              }
                            : null,
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Popular Sites',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          children: zeroSites,
          physics: BouncingScrollPhysics(),
        )
      ]..add(
          Padding(
            padding: EdgeInsets.all(40.0),
          ),
        ),
    );
  }
}
