import '../imports.dart';

final uiStore = Get.put(UiController());

class UiController extends GetxController {
  late PersistentBottomSheetController currentBottomSheetController;
  final isWindowVisible = false.obs;

  Rx<AppUpdate> appUpdate = AppUpdate.NOT_AVAILABLE.obs;

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

  Rx<ZeroNetStatus> zeroNetStatus = ZeroNetStatus.NOT_RUNNING.obs;

  void setZeroNetStatus(ZeroNetStatus status) {
    zeroNetStatus.value = status;
  }
}
