import 'package:mobx/mobx.dart';

import '../imports.dart';

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
  void updateCurrentAppRoute(AppRoute appRoute) => currentAppRoute = appRoute;

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
