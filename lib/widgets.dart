import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:auto_size_text/auto_size_text.dart';
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

  checkInitStatus() async {
    try {
      String url = defZeroNetUrl + Utils.initialSites['ZeroHello']['url'];
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

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    List wrapChildren = <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: GestureDetector(
          child: Chip(
            label: Text('Create New Profile'),
          ),
          onTap: () {
            if (isZeroNetUserDataExists()) {
              showDialogW(
                context: context,
                title: 'Provide A Name for Existing Profile',
                body: ProfileSwitcherUserNameEditText(),
                actionOk: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Create'),
                      onPressed: () {
                        if (username.isNotEmpty) {
                          File file = File(getZeroNetUsersFilePath());
                          var f = file.renameSync(getZeroNetDataDir().path +
                              '/users-$username.json');
                          if (f.existsSync()) {
                            if (file.existsSync()) file.deleteSync();
                            Navigator.pop(context);
                            ZeroNet.instance.shutDown();
                            runZeroNet();
                          }
                          setState(() {});
                        } else {
                          setState(() {
                            validUsername = false;
                          });
                        }
                      },
                    ),
                    FlatButton(
                      child: Text('Backup'),
                      onPressed: () => backUpUserJsonFile(context),
                    ),
                  ],
                ),
              );
            } else
              zeronetNotInit(context);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: GestureDetector(
          child: Chip(
            label: Text('Import Profile'),
          ),
          onTap: () async {
            var file = await getUserJsonFile();
            if (file != null && file.path.endsWith('users.json')) {
              var isSameUser = file.existsSync()
                  ? getZeroNetUsersFilePath() == file.path
                  : false;
              showDialogW(
                context: context,
                title: 'Restore Profile ?',
                body: Text(
                  'this will delete the existing profile, '
                  'backup existing profile using backup button below\n\n'
                  'Selected Userfile : \n'
                  '$filePath'
                  '\n\n${isSameUser ? 'You can only select users.json file, outside zeronet data folder' : ''}',
                ),
                actionOk: Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: isSameUser
                          ? null
                          : () async {
                              File f = File(getZeroNetUsersFilePath());
                              print(f.path);
                              if (!isSameUser) {
                                if (f.existsSync()) f.deleteSync();
                                f.createSync();
                                f.writeAsStringSync(file.readAsStringSync());
                                setState(() {});
                                try {
                                  ZeroNet.instance.shutDown();
                                } catch (e) {
                                  print(e);
                                }
                                runZeroNet();
                                Navigator.pop(context);
                              }
                            },
                      child: Text(
                        'Restore',
                      ),
                    ),
                    FlatButton(
                      child: Text('Backup'),
                      onPressed: () => backUpUserJsonFile(context),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: GestureDetector(
          child: Chip(
            label: Text('Backup Profile'),
          ),
          onTap: () => backUpUserJsonFile(context),
        ),
      ),
    ];
    getZeroNameProfiles().forEach((profile) {
      wrapChildren.insert(
        0,
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            child: Chip(
              label: Text(profile),
            ),
            onTap: () {
              showDialogW(
                context: context,
                title: 'Switch Profile to $profile ?',
                body: Text(
                  'this will delete the existing profile, '
                  'backup existing profile using backup button below',
                ),
                actionOk: Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        File f = File(getZeroNetUsersFilePath());
                        if (f.existsSync()) {
                          f.deleteSync();
                        }
                        File file = File(
                            getZeroNetDataDir().path + '/users-$profile.json');
                        if (file.existsSync()) {
                          file.renameSync(
                              getZeroNetDataDir().path + '/users.json');
                          setState(() {});
                          ZeroNet.instance.shutDown();
                          runZeroNet();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Switch',
                      ),
                    ),
                    FlatButton(
                      child: Text('Backup'),
                      onPressed: () => backUpUserJsonFile(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
    return ListView.builder(
      itemCount: defSettings.keys.length,
      itemBuilder: (c, i) {
        var key = defSettings.keys.toList()[i];
        var map = defSettings;
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AutoSizeText(
                          map[key].name,
                          maxLines: 1,
                          maxFontSize: 18,
                        ),
                        if (map[key] is ToggleSetting)
                          Observer(
                            builder: (context) {
                              var map = varStore.settings;
                              //TODO: Check this, if it is removing non toggle settings from settings file
                              map.removeWhere((e, w) => !(w is ToggleSetting));
                              return Switch(
                                value:
                                    (map[key] as ToggleSetting)?.value ?? false,
                                onChanged: (v) async {
                                  (map[key] as ToggleSetting)..value = v;
                                  Map<String, Setting> m = {};
                                  map.keys.forEach((k) {
                                    m[k] = map[k];
                                  });
                                  if (key == batteryOptimisation && v) {
                                    final isOptimised =
                                        await isBatteryOptimised();
                                    (m[key] as ToggleSetting)
                                      ..value = (!isOptimised)
                                          ? await askBatteryOptimisation()
                                          : true;
                                  } else if (key == publicDataFolder) {
                                    String str =
                                        'data_dir = ${v ? appPrivDir.path : zeroNetDir}/data';
                                    writeZeroNetConf(str);
                                  }
                                  saveSettings(m);
                                  varStore.updateSetting(
                                    (map[key] as ToggleSetting)
                                      ..value = (m[key] as ToggleSetting).value,
                                  );
                                },
                              );
                            },
                          ),
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
                    if (map[key] is MapSetting)
                      if (key == profileSwitcher)
                        ((map[key] as MapSetting).map['selected'] as String)
                                .isEmpty
                            ? Wrap(
                                children: wrapChildren,
                              )
                            : GestureDetector(
                                child: Chip(
                                  label: Text('Create Profile'),
                                ),
                                onTap: () {},
                              )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

var username = '';
var errorText = '';
var validUsername = false;

class ProfileSwitcherUserNameEditText extends StatefulWidget {
  @override
  _ProfileSwitcherUserNameEditTextState createState() =>
      _ProfileSwitcherUserNameEditTextState();
}

class _ProfileSwitcherUserNameEditTextState
    extends State<ProfileSwitcherUserNameEditText> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = getZeroIdUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: <Widget>[
        Text(
          'Always remember to backup users.json before doing anything because, '
          'we are not able to tell when a software will fail. '
          'Click Backup below to backup your Existing users.json file.\n',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        Text('Username Phrase :'),
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
          ),
          child: TextField(
            controller: _controller,
            onChanged: (text) {
              username = text;
              var valid = text.isNotEmpty;
              if (valid) {
                if (text.contains(' ')) {
                  errorText = 'username can\'t contain spaces';
                  valid = false;
                } else if (text.length < 6) {
                  errorText = 'username can\'t be less than 6 characters.';
                  valid = false;
                } else if (File(getZeroNetDataDir().path + '/users-$text.json')
                    .existsSync()) {
                  errorText = 'username already exists, choose different one.';
                  valid = false;
                }
              } else {
                errorText = 'username can\'t be Empty';
              }
              setState(() {
                validUsername = valid;
              });
            },
            style: TextStyle(
              fontSize: 18.0,
            ),
            decoration: InputDecoration(
              hintText: 'username',
              errorText: validUsername ? null : errorText,
            ),
          ),
        ),
      ],
    );
  }
}
