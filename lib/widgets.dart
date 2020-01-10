import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:zeronet_ws/zeronet_ws.dart';

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
    Please Wait! This may take a while, happens 
    only first time, Don't Press Back button.
    If You Accidentally Pressed Back,
    Clean App Storage in Settings or 
    Uninstall and Reinstall The App.
    """;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    check();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png'),
            Padding(
              padding: EdgeInsets.all(24.0),
            ),
            Observer(
              builder: (context) {
                var status = varStore.loadingStatus;
                return Text(
                  status,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                  ),
                );
              },
            ),
            //TODO ? Next Version.
            Observer(builder: (context) {
              var percent = varStore.loadingPercent;
              return Text(
                '($percent%)',
                style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                ),
              );
            }),
            Text(
              warning,
              style: TextStyle(
                fontSize: 12.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                                  viewBrowser = true;
                                  setState(() {});
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
      String key = await ZeroNet.instance.getWrapperKey(url);
      zeroNetUrl = defZeroNetUrl;
      varStore.zeroNetWrapperKey = key;
      varStore.setZeroNetStatus('Running');
      ZeroNet.instance
          .connect(zeroNetIPwithPort(defZeroNetUrl), Utils.urlHello);
      showZeroNetRunningNotification(enableVibration: false);
      testUrl();
    } catch (e) {
      if (!firstTime && varStore.settings[autoStartZeroNet].value == true)
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
        print(message.message);
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
    if (viewBrowser)
      SystemChrome.setEnabledSystemUIOverlays([]);
    else
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
                ? Observer(builder: (context) {
                    return ListView.builder(
                      itemCount: varStore.settings.keys.length,
                      itemBuilder: (c, i) {
                        var key = varStore.settings.keys.toList()[i];
                        var map = varStore.settings;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 10.0,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          map[key].name,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        Switch(
                                          value: map[key].value,
                                          onChanged: (v) async {
                                            map[key]..value = v;
                                            Map<String, Setting> m = {};
                                            map.keys.forEach((k) {
                                              m[k] = map[k];
                                            });
                                            if (key == batteryOptimisation &&
                                                v) {
                                              m[key]
                                                ..value =
                                                    await askBatteryOptimisation();
                                            } else if (key ==
                                                publicDataFolder) {
                                              String str =
                                                  'data_dir = ${v ? appPrivDir.path : zeroNetDir}/data';
                                              writeZeroNetConf(str);
                                            }
                                            saveSettings(m);
                                            varStore.updateSetting(
                                              map[key]..value = m[key].value,
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        map[key].description,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  })
                : SingleChildScrollView(
                    child: showLog
                        ? Observer(
                            builder: (c) {
                              return Text(varStore.zeroNetLog);
                            },
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
                                    child: Text(
                                      'Status',
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Observer(
                                      builder: (c) {
                                        if (varStore.zeroNetStatus == 'Running')
                                          ZeroNet.instance.connect(
                                              zeroNetIPwithPort(zeroNetUrl),
                                              Utils.urlHello);
                                        return Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Chip(
                                                backgroundColor: varStore
                                                            .zeroNetStatus ==
                                                        'Running'
                                                    ? Colors.greenAccent
                                                    : (varStore.zeroNetStatus ==
                                                            'Not Running')
                                                        ? Colors.grey
                                                        : Colors.orange,
                                                padding: EdgeInsets.all(8.0),
                                                label: Text(
                                                  varStore.zeroNetStatus,
                                                ),
                                              ),
                                            ),
                                            if (varStore.zeroNetStatus ==
                                                'Running')
                                              GestureDetector(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Chip(
                                                    backgroundColor: Colors.red,
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    label: Text(
                                                      'Stop',
                                                    ),
                                                  ),
                                                ),
                                                onTap: shutDownZeronet,
                                              ),
                                            if (varStore.zeroNetStatus ==
                                                'Running')
                                              GestureDetector(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Chip(
                                                    backgroundColor:
                                                        Colors.blueAccent,
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    label: Text(
                                                      'More Info',
                                                    ),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  ZeroNet.instance.siteInfo();
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
                              zeroNetSites(),
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
                    onPressed: runZeroNet,
                  ),
          );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
