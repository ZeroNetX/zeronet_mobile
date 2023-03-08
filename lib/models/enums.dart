import '../dashboard/imports.dart';
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
            (siteUiController.settings[autoStartZeroNet] as ToggleSetting)
                .value!;
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
        siteUiController.updateCurrentAppRoute(AppRoute.LogPage);
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
