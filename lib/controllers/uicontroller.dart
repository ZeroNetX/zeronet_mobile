import '../imports.dart';

final uiStore = Get.put(UiController());

class UiController extends GetxController {
  PersistentBottomSheetController currentBottomSheetController;

  var appUpdate = AppUpdate.NOT_AVAILABLE.obs;

  void updateInAppUpdateAvailable(AppUpdate available) =>
      appUpdate.value = available;

  var showSnackReply = false.obs;

  void updateShowSnackReply(bool show) {
    showSnackReply.value = show;
  }

  var reload = 0.obs;

  void updateReload(int i) {
    reload.value = i;
  }

  var currentSiteInfo = SiteInfo().obs;

  void updateCurrentSiteInfo(SiteInfo siteInfo) {
    currentSiteInfo.update((val) {
      val.address = siteInfo.address;
      val.peers = siteInfo.peers;
      val.size = siteInfo.size;
      val.files = siteInfo.files;
      val.serving = siteInfo.serving;
      val.siteAdded = siteInfo.siteAdded;
      val.siteModified = siteInfo.siteModified;
      val.siteCodeUpdated = siteInfo.siteCodeUpdated;
    });
  }

  var currentAppRoute = AppRoute.Home.obs;

  void updateCurrentAppRoute(AppRoute appRoute) =>
      currentAppRoute.value = appRoute;

  var currentTheme = AppTheme.Light.obs;

  void setTheme(AppTheme theme) {
    currentTheme.value = theme;
  }

  var zeroNetStatus = ZeroNetStatus.NOT_RUNNING.obs;

  void setZeroNetStatus(ZeroNetStatus status) {
    zeroNetStatus.value = status;
  }

  var zeroNetUserStatus = ZeroNetUserStatus.NOT_REGISTERED.obs;

  void setZeroNetUserStatus(ZeroNetUserStatus status) {
    zeroNetUserStatus.value = status;
  }

  var zeroNetUserId = ''.obs;

  void setZeroNetUserId(String id) {
    zeroNetUserId.value = id;
  }
}
