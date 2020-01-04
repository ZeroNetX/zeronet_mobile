import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
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
  String warning = """
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

class ZeroNetSites extends StatefulWidget {
  @override
  _ZeroNetSitesState createState() => _ZeroNetSitesState();
}

class _ZeroNetSitesState extends State<ZeroNetSites> {
  @override
  initState() {
    testUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      // constraints: BoxConstraints.expand(),
      child: GridView(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1,
        ),
        children: zeroNetSites(),
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
  String startZeroNetLog = 'Starting ZeroNet';
  String log = 'Click on Fab to Run ZeroNet\n';
  String logRunning = 'Running ZeroNet\n';
  String uiServerLog = 'Ui.UiServer';

  @override
  initState() {
    checkInitStatus();
    super.initState();
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
    if (varStore.zeroNetStatus != 'Running') {
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

  @override
  Widget build(BuildContext context) {
    // unZipinBg();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      appBar: AppBar(
        title: Text('ZeroNet Mobile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.content_paste),
            onPressed: () {
              showLog = !showLog;
              setState(() {});
            },
          )
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
                                        : Colors.yellowAccent,
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
                      children: <Widget>[]..addAll(zeroNetSites()),
                    ),
                    Padding(
                      padding: EdgeInsets.all(40.0),
                    )
                  ],
                )),
      floatingActionButton: FloatingActionButton(
        child: Observer(
          builder: (c) {
            if (varStore.zeroNetStatus == 'Running') return Icon(Icons.stop);
            return Icon(Icons.play_arrow);
          },
        ),
        onPressed: _runZeroNet,
      ),
    );
  }
}
