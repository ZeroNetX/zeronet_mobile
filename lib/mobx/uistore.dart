import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:zeronet/models/enums.dart';
import 'package:zeronet/models/models.dart';

// Include generated file
part 'uistore.g.dart';

// This is the class used by rest of your codebase
final uiStore = UiStore();

class UiStore = _UiStore with _$UiStore;

// The store-class
abstract class _UiStore with Store {
  PersistentBottomSheetController currentBottomSheetController;

  @observable
  AppUpdate appUpdate = AppUpdate.NOT_AVAILABLE;

  @action
  void updateInAppUpdateAvailable(AppUpdate available) => appUpdate = available;

  @observable
  bool showSnackReply = false;

  @action
  void updateShowSnackReply(bool show) {
    showSnackReply = show;
  }

  @observable
  int reload = 0;

  @action
  void updateReload(int i) {
    reload = i;
  }

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
  AppTheme currentTheme = AppTheme.Light;

  @action
  void setTheme(AppTheme theme) {
    currentTheme = theme;
  }

  @observable
  ZeroNetStatus zeroNetStatus = ZeroNetStatus.NOT_RUNNING;

  @action
  void setZeroNetStatus(ZeroNetStatus status) {
    zeroNetStatus = status;
  }
}
