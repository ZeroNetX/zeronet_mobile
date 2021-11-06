import '../imports.dart';

class ZeroNetAppBar extends StatelessWidget {
  const ZeroNetAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            uiStore.currentAppRoute.value.title,
            style: GoogleFonts.roboto(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: uiStore.currentTheme.value.primaryTextColor,
            ),
          ),
          Row(
            children: [
              if (uiStore.currentAppRoute.value == AppRoute.Settings)
                InkWell(
                  child: Icon(
                    OMIcons.info,
                    size: 32.0,
                    color: uiStore.currentTheme.value.primaryTextColor,
                  ),
                  onTap: () =>
                      uiStore.updateCurrentAppRoute(AppRoute.AboutPage),
                ),
              if (uiStore.currentAppRoute.value == AppRoute.Settings)
                Padding(padding: const EdgeInsets.only(right: 20.0)),
              InkWell(
                child: Icon(
                  uiStore.currentAppRoute.value.icon,
                  size: 32.0,
                  color: uiStore.currentTheme.value.primaryTextColor,
                ),
                onTap: uiStore.currentAppRoute.value.onClick,
              )
            ],
          )
        ],
      );
    });
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
    List<String> disabledPlugins = [];
    var pluginsPath = zeroNetDir + '/plugins/';
    Directory(pluginsPath).listSync().forEach((entity) {
      var pycacheDir = entity.path.endsWith('__pycache__');
      if (entity is Directory && !pycacheDir) {
        printOut(entity.path);
        String pluginName = entity.path.replaceAll(pluginsPath, '');
        if (pluginName.startsWith('disabled-')) {
          pluginName = pluginName.replaceAll('disabled-', '');
          disabledPlugins.add(pluginName);
        }
        plugins.insert(0, pluginName);
      }
    });
    plugins.sort();
    return Container(
      width: size.width,
      child: SingleChildScrollView(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: plugins.length,
          itemBuilder: (ctx, i) {
            final isDisabled = disabledPlugins.contains(plugins[i]);
            final pluginName = plugins[i];
            if (pluginName == 'MyDonationMessage') {
              if (!kisProUser) return Container();
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  pluginName,
                  style: TextStyle(
                    color: uiStore.currentTheme.value.primaryTextColor,
                  ),
                ),
                Switch(
                  onChanged: (value) {
                    if (isDisabled)
                      Directory(pluginsPath + 'disabled-' + plugins[i])
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
          strController.backupWarningStr.value,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        Text(
          strController.usernamePhraseStr.value,
          style: TextStyle(
            color: uiStore.currentTheme.value.primaryTextColor,
          ),
        ),
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
                  errorText = strController.usrnameWarning2Str.value;
                  valid = false;
                } else if (text.length < 6) {
                  errorText = strController.usrnameWarning3Str.value;
                  valid = false;
                } else if (File(getZeroNetDataDir().path + '/users-$text.json')
                    .existsSync()) {
                  errorText = strController.usrnameWarning4Str.value;
                  valid = false;
                }
              } else {
                errorText = strController.usrnameWarning1Str.value;
              }
              setState(() {
                validUsername = valid;
              });
            },
            style: TextStyle(
              fontSize: 18.0,
              color: uiStore.currentTheme.value.primaryTextColor,
            ),
            decoration: InputDecoration(
              hintText: strController.usernameStr.value.toLowerCase(),
              errorText: validUsername ? null : errorText,
              hintStyle: TextStyle(
                color: uiStore.currentTheme.value.primaryTextColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ClickableTextWidget extends StatelessWidget {
  ClickableTextWidget({
    this.text,
    this.textStyle,
    this.onClick,
  });

  final String text;
  final TextStyle textStyle;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        style: textStyle,
        recognizer: TapGestureRecognizer()..onTap = onClick,
      ),
    );
  }
}
