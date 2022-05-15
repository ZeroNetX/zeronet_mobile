import '../others/zeronet_isolate.dart';
import '../imports.dart';

enum ZeroNetStatus {
  NOT_RUNNING,
  INITIALISING,
  RUNNING,
  RUNNING_WITH_TOR,
  ERROR,
}

extension ZeroNetStatusExt on ZeroNetStatus {
  get message {
    switch (this) {
      case ZeroNetStatus.NOT_RUNNING:
        return strController.statusNotRunningStr.value;
      case ZeroNetStatus.INITIALISING:
        return strController.statusInitializingStr.value;
      case ZeroNetStatus.RUNNING:
        return strController.statusRunningStr.value;
      case ZeroNetStatus.RUNNING_WITH_TOR:
        return strController.statusRunningWithTorStr.value;
      case ZeroNetStatus.ERROR:
        return strController.statusErrorStr.value;
      default:
    }
  }

  get actionText {
    switch (this) {
      case ZeroNetStatus.NOT_RUNNING:
        return strController.startStr.value;
      case ZeroNetStatus.INITIALISING:
        return strController.pleaseWaitStr.value;
      case ZeroNetStatus.RUNNING:
      case ZeroNetStatus.RUNNING_WITH_TOR:
        return strController.stopStr.value;
      case ZeroNetStatus.ERROR:
        return strController.viewLogStr.value;
      default:
    }
  }

  void onAction() {
    switch (this) {
      case ZeroNetStatus.NOT_RUNNING:
        printOut('onAction()');
        printOut('ZeroNetStatus.NOT_RUNNING');
        if (PlatformExt.isMobile && !patchChecked && checkPatchNeeded()) {
          var zeroNetRevision = getZeroNetRevision(zeroNetDir);
          downloadPatch('$zeroNetRevision').then((_) {
            checkPatchAndApply(
              tempDir!.path + '/patches/$zeroNetRevision',
              zeronetDir,
            );
          });
          patchChecked = true;
        }
        var autoStart =
            (varStore.settings[autoStartZeroNet] as ToggleSetting).value!;
        runZeroNetService(autoStart: autoStart);
        break;
      case ZeroNetStatus.RUNNING:
      case ZeroNetStatus.RUNNING_WITH_TOR:
        shutDownZeronet();
        // if (PlatformExt.isMobile()) flutterWebViewPlugin.close();
        // FlutterBackgroundService().stopBackgroundService();
        manuallyStoppedZeroNet = true;
        break;
      case ZeroNetStatus.ERROR:
        uiStore.updateCurrentAppRoute(AppRoute.LogPage);
        break;
      default:
        return null;
    }
  }

  get actionBtnColor {
    switch (this) {
      case ZeroNetStatus.NOT_RUNNING:
        return Color(0xFF52F7C5);
      case ZeroNetStatus.INITIALISING:
        return Color(0xFF5A53FF);
      case ZeroNetStatus.RUNNING:
      case ZeroNetStatus.RUNNING_WITH_TOR:
        return Color(0xFFF6595F);
      case ZeroNetStatus.ERROR:
        return Color(0xFF5A53FF);
      default:
    }
  }

  get statusChipColor {
    switch (this) {
      case ZeroNetStatus.NOT_RUNNING:
        return Color(0xFFF6595F);
      case ZeroNetStatus.INITIALISING:
        return Color(0xFF5A53FF);
      case ZeroNetStatus.RUNNING:
      case ZeroNetStatus.RUNNING_WITH_TOR:
        return Color(0xFF52F7C5);
      case ZeroNetStatus.ERROR:
        return Color(0xFFF6595F);
      default:
    }
  }
}

enum ZeroNetUserStatus {
  NOT_REGISTERED,
  REGISTERED,
}

extension ZeroNetUserStatusExt on ZeroNetUserStatus {
  get message {
    switch (this) {
      case ZeroNetUserStatus.NOT_REGISTERED:
        return strController.userNameNotCreatedStr.value;
      case ZeroNetUserStatus.REGISTERED:
        return uiStore.zeroNetUserId.value;
      default:
    }
  }

  get actionText {
    switch (this) {
      case ZeroNetUserStatus.NOT_REGISTERED:
        return strController.createStr.value;
      case ZeroNetUserStatus.REGISTERED:
        return strController.switchStr.value;
      default:
    }
  }

  void onAction() {
    switch (this) {
      case ZeroNetUserStatus.NOT_REGISTERED:
        browserUrl = defZeroNetUrl + Utils.urlCryptoId;
        if (PlatformExt.isMobile) {
          uiStore.updateCurrentAppRoute(AppRoute.ZeroBrowser);
        } else {
          launchUrl(Uri.parse(browserUrl));
        }
        break;
      case ZeroNetUserStatus.REGISTERED:
        MapOptions.CREATE_PROFILE.onClick(Get.context);
        break;
      default:
        return null;
    }
  }

  get actionBtnColor {
    switch (this) {
      case ZeroNetUserStatus.NOT_REGISTERED:
      case ZeroNetUserStatus.REGISTERED:
        return Color(0xFF52F7C5);
      default:
    }
  }

  get statusChipColor {
    switch (this) {
      case ZeroNetUserStatus.NOT_REGISTERED:
      case ZeroNetUserStatus.REGISTERED:
        return Color(0xFF5A53FF);
      default:
    }
  }
}

enum AppUpdate {
  NOT_AVAILABLE,
  AVAILABLE,
  DOWNLOADING,
  DOWNLOADED,
  INSTALLING,
}

extension AppUpdateExt on AppUpdate {
  get text {
    switch (uiStore.appUpdate.value) {
      case AppUpdate.AVAILABLE:
        return strController.updateStr.value;
      case AppUpdate.DOWNLOADING:
        return strController.downloadingStr.value;
      case AppUpdate.DOWNLOADED:
        return strController.downloadedStr.value;
      case AppUpdate.INSTALLING:
        return strController.installingStr.value;
      default:
        return strController.notAvaliableStr.value;
    }
  }

  void action() {
    switch (uiStore.appUpdate.value) {
      case AppUpdate.AVAILABLE:
        {
          // InAppUpdate.performImmediateUpdate().then((value) =>
          //     uiStore.updateInAppUpdateAvailable(AppUpdate.NOT_AVAILABLE));
          InAppUpdate.startFlexibleUpdate().then((value) =>
              uiStore.updateInAppUpdateAvailable(AppUpdate.DOWNLOADED));
          uiStore.updateInAppUpdateAvailable(AppUpdate.DOWNLOADING);
        }
        break;
      case AppUpdate.DOWNLOADED:
        {
          InAppUpdate.completeFlexibleUpdate().then((value) =>
              uiStore.updateInAppUpdateAvailable(AppUpdate.NOT_AVAILABLE));
          uiStore.updateInAppUpdateAvailable(AppUpdate.INSTALLING);
        }
        break;
      default:
    }
  }
}

enum AppRoute {
  Home,
  Settings,
  ShortcutLoadingPage,
  ZeroBrowser,
  LogPage,
  AboutPage,
}

extension AppRouteExt on AppRoute {
  get title {
    switch (this) {
      case AppRoute.AboutPage:
        return strController.aboutStr.value;
      case AppRoute.Home:
        return 'ZeroNetX';
      case AppRoute.Settings:
        return strController.settingsStr.value;
      case AppRoute.ZeroBrowser:
        return 'Zero${strController.browserStr.value}';
      case AppRoute.LogPage:
        return 'ZeroNet ${strController.logStr.value}';
      default:
    }
  }

  IconData get icon {
    switch (this) {
      case AppRoute.AboutPage:
      case AppRoute.Settings:
      case AppRoute.ZeroBrowser:
      case AppRoute.LogPage:
        return OMIcons.home;
      case AppRoute.Home:
        return OMIcons.settings;
      default:
        return OMIcons.error;
    }
  }

  void onClick() {
    switch (uiStore.currentAppRoute.value) {
      case AppRoute.Home:
        uiStore.updateCurrentAppRoute(AppRoute.Settings);
        break;
      case AppRoute.AboutPage:
      case AppRoute.Settings:
      case AppRoute.LogPage:
      case AppRoute.ZeroBrowser:
        uiStore.updateCurrentAppRoute(AppRoute.Home);
        break;
      default:
    }
  }
}

enum AppTheme {
  Light,
  Dark,
  Black,
}

extension AppThemeExt on AppTheme {
  get primaryColor {
    switch (this) {
      case AppTheme.Light:
        return Colors.white;
      case AppTheme.Dark:
        return Colors.grey[900];
      case AppTheme.Black:
        return Colors.black;
      default:
    }
  }

  get primaryTextColor {
    switch (this) {
      case AppTheme.Light:
        return Colors.black;
      case AppTheme.Dark:
      case AppTheme.Black:
        return Colors.white;
      default:
    }
  }

  get btnTextColor {
    switch (this) {
      case AppTheme.Light:
        return Colors.white;
      case AppTheme.Dark:
        return Colors.white;
      case AppTheme.Black:
        return Colors.white;
      default:
    }
  }

  get cardBgColor {
    switch (this) {
      case AppTheme.Light:
        return Colors.white;
      case AppTheme.Dark:
        return Colors.grey[850];
      case AppTheme.Black:
        return Colors.grey[900];
      default:
    }
  }

  get iconBrightness {
    switch (this) {
      case AppTheme.Light:
        return Brightness.dark;
      case AppTheme.Dark:
      case AppTheme.Black:
        return Brightness.light;
      default:
    }
  }

  get browserBgColor {
    switch (this) {
      case AppTheme.Light:
        return Color(0xFFEDF2F5);
      case AppTheme.Dark:
      case AppTheme.Black:
        return Color(0xFF22272d);
      default:
    }
  }

  get browserIconColor =>
      zeroBrowserTheme == 'light' ? Color(0xFF22272d) : Color(0xFFEDF2F5);

  get titleBarColor => this == AppTheme.Light ? Colors.white : Colors.grey[900];
}
