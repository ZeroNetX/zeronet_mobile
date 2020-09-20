import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:zeronet/mobx/uistore.dart';
import 'package:zeronet/others/zeronet_utils.dart';

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
        runZeroNet();
        break;
      case ZeroNetStatus.RUNNING:
      case ZeroNetStatus.RUNNING_WITH_TOR:
        shutDownZeronet();
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
    switch (uiStore.appUpdate) {
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
    switch (uiStore.appUpdate) {
      case AppUpdate.AVAILABLE:
        {
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
}

extension AppRouteExt on AppRoute {
  get title {
    switch (this) {
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
}

enum AppTheme {
  Light,
  Dark,
  Black,
}
