import 'package:zeronet/others/zeronet_isolate.dart';

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
        return 'Not Running';
        break;
      case ZeroNetStatus.INITIALISING:
        return 'Initialising...';
        break;
      case ZeroNetStatus.RUNNING:
        return 'Running';
        break;
      case ZeroNetStatus.RUNNING_WITH_TOR:
        return 'Running with Tor';
        break;
      case ZeroNetStatus.ERROR:
        return 'Error';
        break;
      default:
    }
  }

  get actionText {
    switch (this) {
      case ZeroNetStatus.NOT_RUNNING:
        return 'Start';
        break;
      case ZeroNetStatus.INITIALISING:
        return 'Please WAIT!';
        break;
      case ZeroNetStatus.RUNNING:
      case ZeroNetStatus.RUNNING_WITH_TOR:
        return 'Stop';
        break;
      case ZeroNetStatus.ERROR:
        return 'View Log';
        break;
      default:
    }
  }

  void onAction() {
    switch (this) {
      case ZeroNetStatus.NOT_RUNNING:
        printOut('onAction()');
        printOut('ZeroNetStatus.NOT_RUNNING');
        var autoStart =
            (varStore.settings[autoStartZeroNet] as ToggleSetting).value;
        runZeroNetService(autoStart: autoStart);
        break;
      case ZeroNetStatus.RUNNING:
      case ZeroNetStatus.RUNNING_WITH_TOR:
        shutDownZeronet();
        ZeroBrowser.flutterWebViewPlugin.close();
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
        return 'Update';
        break;
      case AppUpdate.DOWNLOADING:
        return 'Downloading';
        break;
      case AppUpdate.DOWNLOADED:
        return 'Downloaded';
        break;
      case AppUpdate.INSTALLING:
        return 'Installing';
        break;
      default:
        return 'Not Available';
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
        return 'About';
        break;
      case AppRoute.Home:
        return 'ZeroNet Mobile';
        break;
      case AppRoute.Settings:
        return 'Settings';
        break;
      case AppRoute.ZeroBrowser:
        return 'ZeroBrowser';
        break;
      case AppRoute.LogPage:
        return 'ZeroNet Log';
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
