import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeronet/zeronet/zeronet.dart';

import 'common.dart';
import 'mobx/varstore.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZeroNet Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Observer(
        builder: (context) {
          if (varStore.zeroNetInstalled) return MyHomePage();
          return Loading();
        },
      ),
    );
  }
}

class Loading extends StatelessWidget {
  // String data = 'Loading';
  final String warning = """
        Please Wait! This may take a while, 
        happens only first time, 
        Don't Press Back button.
        """;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    check();
    return Scaffold(
      body: Center(
        child: Observer(
          builder: (context) {
            var percent = varStore.loadingPercent;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/logo.png'),
                Padding(
                  padding: EdgeInsets.all(24.0),
                ),
                Text(
                  varStore.loadingStatus,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                //TODO ? Next Version.
                Text(
                  '($percent%)',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  warning,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// class ZeroNetSites extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       children: zeroNetSites(),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showLog = false;
  String startZeroNetLog = 'Starting ZeroNet';
  String log = 'Click on Fab to Run ZeroNet\n';
  String logRunning = 'Running ZeroNet\n';
  String uiServerLog = 'Ui.UiServer';

  @override
  initState() {
    checkInitStatus();
    super.initState();
  }

  _reload() => this.mounted ? setState(() {}) : null;

  Widget zeroNetSites() {
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
                      child: Text(
                        name,
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
                      child: Text(
                        description,
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
                    child: OutlineButton(
                      borderSide: BorderSide(color: Colors.white),
                      child: Text(
                        'Open',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (canLaunchUrl) {
                          launch(zeroNetUrl + url);
                        } else {
                          testUrl();
                        }
                      },
                    ),
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
        Wrap(
          children: []..addAll(zeroSites),
        )
      ]..add(
          Padding(
            padding: EdgeInsets.all(40.0),
          ),
        ),
    );
  }

  checkInitStatus() async {
    try {
      String url = defZeroNetUrl + Utils.initialSites['ZeroHello']['url'];
      String key = await ZeroNet().getWrapperKey(url);
      zeroNetUrl = defZeroNetUrl;
      varStore.zeroNetWrapperKey = key;
      varStore.setZeroNetStatus('Running');
      testUrl();
    } catch (e) {
      print(e);
    }
  }

  printOut(Object object) {
    if (object is String) {
      if (!object.contains(startZeroNetLog)) {
        print(object);
        if (object.contains(uiServerLog)) {
          // var s = object.replaceAll(uiServerLog, '');
          int httpI = object.indexOf('http');
          // int columnI = object.indexOf(':');
          int end = object.indexOf('/\n');
          // int slashI = object.indexOf('/', columnI);
          if (zeroNetUrl.isEmpty && httpI != -1) {
            var _zeroNetUrl = (end == -1)
                ? object.substring(httpI)
                : object.substring(httpI, end + 1);
            if (zeroNetUrl != _zeroNetUrl) zeroNetUrl = _zeroNetUrl;
            testUrl();
          }
        }
        if (object.contains('Server port opened')) {
          if (zeroNetUrl.isNotEmpty) {
            if (varStore.zeroNetWrapperKey.isEmpty) {
              ZeroNet()
                  .getWrapperKey(
                      zeroNetUrl + Utils.initialSites['ZeroHello']['url'])
                  .then((value) {
                if (value != null) {
                  ZeroNet.wrapperKey = value;
                  varStore.zeroNetWrapperKey = value;
                  browserUrl = zeroNetUrl;
                  varStore.setZeroNetStatus('Running');
                }
              });
            }
          }
        }
      }
    }
    setState(() {
      log = log + object + '\n';
    });
  }

  Process zero;
  _runZeroNet() {
    if (varStore.zeroNetStatus == 'Not Running') {
      varStore.setZeroNetStatus('Initialising...');
      log = '';
      printOut(logRunning);
      printOut(startZeroNetLog + '\n');
      var bin = '$dataDir/usr/bin';
      var exec = '$bin/python';
      var libDir = '$dataDir/usr/lib';
      var libDir64 = '$dataDir/usr/lib64';
      var zeronetDir = '$dataDir/ZeroNet-py3';
      var zeronet = '$zeronetDir/zeronet.py';
      Process.start('$exec', [
        zeronet
      ], environment: {
        "LD_LIBRARY_PATH": "$libDir:$libDir64:/system/lib64",
      }).then((proc) {
        zero = proc;
        zero.stderr.listen((onData) {
          printOut(utf8.decode(onData));
        });
        zero.stdout.listen((onData) {
          printOut(utf8.decode(onData));
        });
      });
    }
  }

  bool viewBrowser = true;

// ignore: prefer_collection_literals
  final Set<JavascriptChannel> jsChannels = [
    JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }),
  ].toSet();
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  AppBar appBar() {
    return AppBar(
      title: const Text('ZeroNet Mobile'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            viewBrowser = !viewBrowser;
            _reload();
          },
        ),
      ],
    );
  }

  Widget webView() => Stack(
        children: <Widget>[
          // appBar(),
          Padding(
            padding: const EdgeInsets.only(top: 0.0), //80.0
            child: WebviewScaffold(
              url: browserUrl,
              // javascriptChannels: jsChannels,
              mediaPlaybackRequiresUserGesture: false,
              appCacheEnabled: true,
              appBar: appBar(),
              withZoom: true,
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

  @override
  Widget build(BuildContext context) {
    if (viewBrowser)
      SystemChrome.setEnabledSystemUIOverlays([]);
    else
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return viewBrowser
        ? webView()
        : Scaffold(
            appBar: AppBar(
              title: Text('ZeroNet Mobile'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.content_paste),
                  onPressed: () {
                    showLog = !showLog;
                    _reload();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.open_in_browser),
                  onPressed: () {
                    viewBrowser = !viewBrowser;
                    _reload();
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
                child: showLog
                    ? Text(log)
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'ZeroNet Status',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Observer(
                                  builder: (c) {
                                    return Chip(
                                      backgroundColor:
                                          varStore.zeroNetStatus == 'Running'
                                              ? Colors.greenAccent
                                              : (varStore.zeroNetStatus ==
                                                      'Not Running')
                                                  ? Colors.grey
                                                  : Colors.orange,
                                      padding: EdgeInsets.all(8.0),
                                      label: Text(
                                        varStore.zeroNetStatus,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          zeroNetSites(),
                        ],
                      )),
            floatingActionButton: FloatingActionButton(
              child: Observer(
                builder: (c) {
                  if (varStore.zeroNetStatus == 'Not Running')
                    return Icon(Icons.play_arrow);
                  return Icon(Icons.stop);
                },
              ),
              onPressed: _runZeroNet,
            ),
          );
  }
}
