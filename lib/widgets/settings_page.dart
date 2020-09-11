import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:zeronet_ws/zeronet_ws.dart';

import '../mobx/varstore.dart';
import '../others/common.dart';
import '../others/constants.dart';
import '../models/models.dart';
import '../others/native.dart';
import '../others/utils.dart';
import '../others/zeronet_utils.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  _reload() => this.mounted ? setState(() {}) : null;

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
                          username = '';
                          _reload();
                        } else {
                          validUsername = false;
                          _reload();
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
                              printOut(f.path);
                              if (!isSameUser) {
                                if (f.existsSync()) f.deleteSync();
                                f.createSync();
                                f.writeAsStringSync(file.readAsStringSync());
                                _reload();
                                try {
                                  ZeroNet.instance.shutDown();
                                } catch (e) {
                                  printOut(e);
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
                actionOk: profileSwitcherActionOk(profile, context),
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
        if (firstTime && key == profileSwitcher) return Container();
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          minFontSize: 18,
                          maxFontSize: 24,
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
                                onChanged:
                                    (map[key] as ToggleSetting).onChanged,
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
                      else if (key == pluginManager)
                        Wrap(
                          children: [
                            GestureDetector(
                              child: Chip(
                                label: Text('Open Plugin Manager'),
                              ),
                              onTap: () {
                                showDialogW(
                                  context: context,
                                  title: pluginManager,
                                  body: PluginManager(),
                                  actionOk: FlatButton(
                                    onPressed: () {
                                      ZeroNet.instance.shutDown();
                                      runZeroNet();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Restart'),
                                  ),
                                );
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 8.0),
                              child: GestureDetector(
                                child: Chip(
                                  label: Text('Load Plugin'),
                                ),
                                onTap: () {
                                  showDialogW(
                                    context: context,
                                    title: 'Install a Plugin',
                                    body: Text(
                                        'This will load plugin to your ZeroNet repo, '
                                        '\nWarning : Loading Unknown/Untrusted plugins may compromise ZeroNet Installation.'),
                                    actionOk: FlatButton(
                                      onPressed: () async {
                                        var file = await getPluginZipFile();
                                        if (file != null) {
                                          Navigator.pop(context);
                                          installPluginDialog(file, context);
                                        }
                                      },
                                      child: Text('Install'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
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

  Row profileSwitcherActionOk(String profile, BuildContext context) {
    return Row(
      children: <Widget>[
        FlatButton(
          onPressed: () {
            File f = File(getZeroNetUsersFilePath());
            if (f.existsSync()) {
              f.deleteSync();
            }
            File file = File(getZeroNetDataDir().path + '/users-$profile.json');
            if (file.existsSync()) {
              file.renameSync(getZeroNetDataDir().path + '/users.json');
              _reload();
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
    );
  }
}

class PluginManager extends StatefulWidget {
  const PluginManager({
    Key key,
  }) : super(key: key);

  @override
  _PluginManagerState createState() => _PluginManagerState();
}

class _PluginManagerState extends State<PluginManager> {
  _reload() => this.mounted ? setState(() {}) : null;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<String> plugins = [];
    var pluginsPath = zeroNetDir + '/plugins/';
    Directory(pluginsPath).listSync().forEach((entity) {
      var pycacheDir = entity.path.endsWith('__pycache__');
      if (entity is Directory && !pycacheDir) {
        printOut(entity.path);
        plugins.insert(0, entity.path.replaceAll(pluginsPath, ''));
      }
    });
    plugins.sort();
    return Container(
      height: size.height * 0.73,
      width: size.width,
      child: ListView.builder(
        itemCount: plugins.length,
        itemBuilder: (ctx, i) {
          final isDisabled = plugins[i].startsWith('disabled-');
          final pluginName = isDisabled
              ? plugins[i].replaceFirst('disabled-', '')
              : plugins[i];
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(pluginName),
              Switch(
                onChanged: (value) {
                  if (isDisabled)
                    Directory(pluginsPath + plugins[i])
                        .renameSync(pluginsPath + pluginName);
                  else
                    Directory(pluginsPath + plugins[i])
                        .renameSync(pluginsPath + 'disabled-' + plugins[i]);
                  _reload();
                },
                value: !isDisabled,
              )
            ],
          );
        },
      ),
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
    final usrName = getZeroIdUserName();
    _controller.text = usrName;
    if (usrName.isNotEmpty) {
      username = usrName;
    }
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
