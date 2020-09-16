import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:zeronet/models/models.dart';
import 'package:zeronet/others/zeronet_utils.dart';

// Include generated file
part 'uistore.g.dart';

// This is the class used by rest of your codebase
final uiStore = UiStore();

class UiStore = _UiStore with _$UiStore;

// The store-class
abstract class _UiStore with Store {
  @observable
  SiteInfo currentSiteInfo = SiteInfo();

  @action
  void updateCurrentSiteInfo(SiteInfo siteInfo) {
    currentSiteInfo = siteInfo;
  }

  @observable
  AppRoute currentAppRoute = AppRoute.Home;

  @action
  void updateCurrentAppRoute(AppRoute appRoute) {
    currentAppRoute = appRoute;
    switch (appRoute) {
      case AppRoute.Home:
        updateAppBarTitle(AppRoute.Home.title);
        updateAppBarIcon(OMIcons.settings);
        break;
      case AppRoute.Settings:
        updateAppBarTitle(AppRoute.Settings.title);
        updateAppBarIcon(OMIcons.home);
        break;
      case AppRoute.ZeroBrowser:
        updateAppBarTitle(AppRoute.ZeroBrowser.title);
        updateAppBarIcon(OMIcons.home);
        break;
      case AppRoute.LogPage:
        updateAppBarTitle(AppRoute.LogPage.title);
        updateAppBarIcon(OMIcons.home);
        break;
      default:
    }
  }

  @observable
  String appBarTitle = AppRoute.Home.title;

  @action
  void updateAppBarTitle(String title) => appBarTitle = title;

  @observable
  IconData appBarIcon = OMIcons.settings;

  @action
  void updateAppBarIcon(IconData icon) => appBarIcon = icon;

  @observable
  Theme currentTheme = Theme.Light;

  @action
  void setTheme(Theme theme) {
    currentTheme = theme;
  }

  @observable
  ZeroNetStatus zeroNetStatus = ZeroNetStatus.NOT_RUNNING;

  @action
  void setZeroNetStatus(ZeroNetStatus status) {
    zeroNetStatus = status;
  }
}

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

enum AppRoute {
  Home,
  Settings,
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

enum Theme {
  Light,
  Dark,
  Black,
}
