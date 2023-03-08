import '../imports.dart';

final varStore = Get.put(VarController());

class VarController extends GetxController {
  var zeroNetWrapperKey = '';
  Rx<ObservableEvent> event = ObservableEvent.none.obs;
  var zeroNetLog = 'ZeroNetX'.obs;
  RxString zeroNetStatus = strController.statusNotRunningStr;
  var zeroNetInstalled = false.obs;
  var zeroNetDownloaded = false.obs;
  RxString loadingStatus = strController.loadingStr;
  var loadingPercent = 0.obs;

  void setObservableEvent(ObservableEvent eve) {
    event.value = eve;
  }

  void setZeroNetLog(String status) {
    zeroNetLog.value = status;
  }

  void setZeroNetStatus(String status) {
    zeroNetStatus.value = status;
  }

  void isZeroNetInstalled(bool installed) {
    zeroNetInstalled.value = installed;
  }

  void isZeroNetDownloaded(bool downloaded) {
    zeroNetDownloaded.value = downloaded;
  }

  void setLoadingStatus(String status) {
    loadingStatus.value = status;
  }

  void setLoadingPercent(int percent) {
    loadingPercent.value = percent;
  }
}

enum ObservableEvent {
  none,
  downloding,
  downloaded,
  installing,
  installed,
}
