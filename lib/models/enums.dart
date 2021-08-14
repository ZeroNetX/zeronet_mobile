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
        break;
      case ZeroNetStatus.INITIALISING:
        return strController.statusInitializingStr.value;
        break;
      case ZeroNetStatus.RUNNING:
        return strController.statusRunningStr.value;
        break;
      case ZeroNetStatus.RUNNING_WITH_TOR:
        return strController.statusRunningWithTorStr.value;
        break;
      case ZeroNetStatus.ERROR:
        return strController.statusErrorStr.value;
        break;
      default:
    }
  }

  get actionText {
    switch (this) {
      case ZeroNetStatus.NOT_RUNNING:
        return strController.startStr.value;
        break;
      case ZeroNetStatus.INITIALISING:
        return strController.pleaseWaitStr.value;
        break;
      case ZeroNetStatus.RUNNING:
      case ZeroNetStatus.RUNNING_WITH_TOR:
        return strController.stopStr.value;
        break;
      case ZeroNetStatus.ERROR:
        return strController.viewLogStr.value;
        break;
      default:
    }
  }

  void onAction() {
    switch (this) {
      case ZeroNetStatus.NOT_RUNNING:
        printOut('onAction()');
        printOut('ZeroNetStatus.NOT_RUNNING');
        if (!patchChecked && checkPatchNeeded()) {
          var zeroNetRevision = getZeroNetRevision(zeroNetDir);
          downloadPatch('$zeroNetRevision').then((_) {
            checkPatchAndApply(
              tempDir.path + '/patches/$zeroNetRevision',
              zeronetDir,
            );
          });
          patchChecked = true;
        }
        var autoStart =
            (varStore.settings[autoStartZeroNet] as ToggleSetting).value;
        runZeroNetService(autoStart: autoStart);
        break;
      case ZeroNetStatus.RUNNING:
      case ZeroNetStatus.RUNNING_WITH_TOR:
        shutDownZeronet();
        flutterWebViewPlugin.close();
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
        break;
      case ZeroNetStatus.INITIALISING:
        return Color(0xFF5A53FF);
        break;
      case ZeroNetStatus.RUNNING:
      case ZeroNetStatus.RUNNING_WITH_TOR:
        return Color(0xFFF6595F);
        break;
      case ZeroNetStatus.ERROR:
        return Color(0xFF5A53FF);
        break;
      default:
    }
  }

  get statusChipColor {
    switch (this) {
      case ZeroNetStatus.NOT_RUNNING:
        return Color(0xFFF6595F);
        break;
      case ZeroNetStatus.INITIALISING:
        return Color(0xFF5A53FF);
        break;
      case ZeroNetStatus.RUNNING:
      case ZeroNetStatus.RUNNING_WITH_TOR:
        return Color(0xFF52F7C5);
        break;
      case ZeroNetStatus.ERROR:
        return Color(0xFFF6595F);
        break;
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
        break;
      case AppUpdate.DOWNLOADING:
        return strController.downloadingStr.value;
        break;
      case AppUpdate.DOWNLOADED:
        return strController.downloadedStr.value;
        break;
      case AppUpdate.INSTALLING:
        return strController.installingStr.value;
        break;
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
        break;
      case AppRoute.Home:
        return 'ZeroNet Mobile';
        break;
      case AppRoute.Settings:
        return strController.settingsStr.value;
        break;
      case AppRoute.ZeroBrowser:
        return 'Zero${strController.browserStr.value}';
        break;
      case AppRoute.LogPage:
        return 'ZeroNet ${strController.logStr.value}';
        break;
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
        break;
      case AppRoute.Home:
        return OMIcons.settings;
        break;
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
        break;
      case AppTheme.Dark:
        return Colors.grey[900];
        break;
      case AppTheme.Black:
        return Colors.black;
        break;
      default:
    }
  }

  get primaryTextColor {
    switch (this) {
      case AppTheme.Light:
        return Colors.black;
        break;
      case AppTheme.Dark:
      case AppTheme.Black:
        return Colors.white;
        break;
      default:
    }
  }

  get btnTextColor {
    switch (this) {
      case AppTheme.Light:
        return Colors.white;
        break;
      case AppTheme.Dark:
        return Colors.white;
        break;
      case AppTheme.Black:
        return Colors.white;
        break;
      default:
    }
  }

  get cardBgColor {
    switch (this) {
      case AppTheme.Light:
        return Colors.white;
        break;
      case AppTheme.Dark:
        return Colors.grey[850];
        break;
      case AppTheme.Black:
        return Colors.grey[900];
        break;
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
        break;
      default:
    }
  }

  get browserBgColor {
    switch (this) {
      case AppTheme.Light:
        return Color(0xFFEDF2F5);
        break;
      case AppTheme.Dark:
      case AppTheme.Black:
        return Color(0xFF22272d);
        break;
      default:
    }
  }

  get browserIconColor =>
      zeroBrowserTheme == 'light' ? Color(0xFF22272d) : Color(0xFFEDF2F5);
}
