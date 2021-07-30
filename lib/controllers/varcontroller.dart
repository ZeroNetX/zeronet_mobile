import 'package:get/get.dart';
import 'package:zeronet/imports.dart';

final varStore = Get.put(VarController());

class VarController extends GetxController {
  var zeroNetWrapperKey = '';
  var settings = <String, Setting>{}.obs;
  var event = ObservableEvent.none.obs;
  var zeroNetLog = 'ZeroNet Mobile'.obs;
  var zeroNetStatus = 'Not Running'.obs;
  var zeroNetInstalled = false.obs;
  var zeroNetDownloaded = false.obs;
  var loadingStatus = 'Loading'.obs;
  var loadingPercent = 0.obs;

  updateSetting(Setting setting) {
    settings[setting.name] = setting;
  }

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

enum ObservableEvent { none, downloding, downloaded, installing, installed }
