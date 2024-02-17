import '../imports.dart';

enum ZeroNetStatus {
  NOT_RUNNING,
  INITIALISING,
  RUNNING,
  RUNNING_WITH_TOR,
  ERROR,
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
