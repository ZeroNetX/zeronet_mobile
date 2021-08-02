import 'package:get/get.dart';

import '../imports.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: uiStore.currentTheme.value.primaryColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(24)),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Column(
                children: <Widget>[
                  ZeroNetAppBar(),
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: Utils.defSettings.keys.length,
                    itemBuilder: (ctx, i) {
                      Setting current =
                          Utils.defSettings[Utils.defSettings.keys.toList()[i]];
                      if (current.name == profileSwitcher) {
                        bool isUsersFileExists = isZeroNetUsersFileExists();
                        if (!isUsersFileExists) return Container();
                      } else if (current.name == enableZeroNetFilters &&
                          firstTime) {
                        return Container();
                      }
                      return SettingsCard(
                        setting: current,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    Key key,
    @required this.setting,
  }) : super(key: key);

  final Setting setting;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Color(0x52000000),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      margin: EdgeInsets.only(bottom: 14.0),
      color: uiStore.currentTheme.value.cardBgColor,
      child: Container(
        // height: 60.0,
        constraints: BoxConstraints(
          minHeight: 60.0,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 6.0,
            bottom: 6.0,
            left: 18.0,
            right: 16.5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        setting.name,
                        maxLines: 1,
                        style: GoogleFonts.roboto(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: uiStore.currentTheme.value.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          size: 28,
                          color: Color(0xFF5A53FF),
                        ),
                        onPressed: () {
                          showBottomSheet(
                            context: context,
                            elevation: 16.0,
                            backgroundColor:
                                uiStore.currentTheme.value.cardBgColor,
                            builder: (ctx) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                constraints: BoxConstraints(
                                  minHeight: 250.0,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                    ),
                                    Container(
                                      height: 5.0,
                                      width: 80.0,
                                      margin: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF5A53FF),
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SettingDetailsSheet(setting),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      if (setting is ToggleSetting)
                        Obx(
                          () {
                            bool enabled = (varStore.settings[setting.name]
                                    as ToggleSetting)
                                .value;
                            return Switch(
                              value: enabled,
                              activeColor: Color(0xFF5380FF),
                              onChanged: (setting as ToggleSetting).onChanged,
                            );
                          },
                        )
                    ],
                  )
                ],
              ),
              if (setting is MapSetting)
                Obx(() {
                  var i = uiStore.reload.value;
                  printOut(i.toString());
                  List<Widget> children = [];
                  var settingL = setting as MapSetting;
                  settingL.options.forEach((element) {
                    children.add(
                      InkWell(
                        borderRadius: BorderRadius.circular(24.0),
                        splashColor: Color(0xFF5380FF),
                        onTap: () {
                          settingL.options[settingL.options.indexOf(element)]
                              .onClick(Get.context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                          child: Chip(
                            elevation: 2.0,
                            backgroundColor:
                                uiStore.currentTheme.value.cardBgColor,
                            label: Text(
                              settingL
                                  .options[settingL.options.indexOf(element)]
                                  .description,
                              maxLines: 1,
                              style: GoogleFonts.roboto(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color:
                                    uiStore.currentTheme.value.primaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                  if ((setting as MapSetting).name == profileSwitcher)
                    getZeroNameProfiles().forEach((profile) {
                      children.insert(
                        0,
                        InkWell(
                          borderRadius: BorderRadius.circular(24.0),
                          splashColor: Color(0xFF5380FF),
                          onTap: () {
                            showDialogW(
                              context: context,
                              title: 'Switch Profile to $profile ?',
                              body: Text(
                                'this will delete the existing profile, '
                                'backup existing profile using backup button below',
                              ),
                              actionOk:
                                  profileSwitcherActionOk(profile, context),
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 3.0, right: 3.0),
                            child: Chip(
                              elevation: 2.0,
                              label: Text(
                                profile,
                                maxLines: 1,
                                style: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  return Wrap(
                    children: children,
                  );
                })
            ],
          ),
        ),
      ),
    );
  }

  Row profileSwitcherActionOk(String profile, BuildContext context) {
    return Row(
      children: <Widget>[
        TextButton(
          onPressed: () {
            File f = File(getZeroNetUsersFilePath());
            if (f.existsSync()) {
              f.deleteSync();
            }
            File file = File(getZeroNetDataDir().path + '/users-$profile.json');
            if (file.existsSync()) {
              file.renameSync(getZeroNetDataDir().path + '/users.json');
              // _reload();
              if (uiStore.zeroNetStatus.value == ZeroNetStatus.RUNNING)
                ZeroNet.instance.shutDown();
              service.sendData({'cmd': 'runZeroNet'});
              Navigator.pop(context);
            }
          },
          child: Text(
            'Switch',
          ),
        ),
        TextButton(
          child: Text('Backup'),
          onPressed: () => backUpUserJsonFile(context),
        ),
      ],
    );
  }
}

class SettingDetailsSheet extends StatelessWidget {
  SettingDetailsSheet(this.setting);
  final Setting setting;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              setting.name,
              maxLines: 1,
              style: GoogleFonts.roboto(
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: uiStore.currentTheme.value.primaryTextColor,
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.all(6.0)),
        Text(
          setting.description,
          style: GoogleFonts.roboto(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: uiStore.currentTheme.value.primaryTextColor,
          ),
        ),
      ],
    );
  }
}
