import '../imports.dart';

final strController = Get.put(StringController());

class StringController extends GetxController {
  final statusNotRunningStr = 'Not Running'.obs;
  final statusInitializingStr = 'Initializing..'.obs;
  final statusStartingStr = 'Starting'.obs;
  final statusRunningStr = 'Running'.obs;
  final statusRunningWithTorStr = 'Running with Tor'.obs;
  final statusErrorStr = 'Error'.obs;
  final loadingPageWarningStr = """
    Please Wait! This may take a while, happens 
    only first time, Don't Press Back button.
    If You Accidentally Pressed Back,
    Clean App Storage in Settings or 
    Uninstall and Reinstall The App.
    """
      .obs;
  final startStr = 'Start'.obs;
  final pleaseWaitStr = 'Please Wait..!'.obs;
  final loadingStr = 'Loading'.obs;
  final stopStr = 'Stop'.obs;
  final viewLogStr = 'View Log'.obs;
  final updateStr = 'Update'.obs;
  final downloadingStr = 'Downloading'.obs;
  final downloadedStr = 'Downloaded'.obs;
  final installingStr = 'Installing'.obs;
  final installationCompletedStr = 'Installation Completed'.obs;
  final notAvaliableStr = 'Not Available'.obs;

  void updateloadingPageWarningStr(String str) =>
      loadingPageWarningStr.value = str;
  void updatestatusNotRunningStr(String str) => statusNotRunningStr.value = str;
  void updatestatusInitializingStr(String str) =>
      statusInitializingStr.value = str;
  void updatestatusStartingStr(String str) => statusStartingStr.value = str;
  void updatestatusRunningStr(String str) => statusRunningStr.value = str;
  void updatestatusRunningWithTorStr(String str) =>
      statusRunningStr.value = str;
  void updatestatusErrorStr(String str) => statusErrorStr.value = str;
  void updatestartStr(String str) => startStr.value = str;
  void updatepleaseWaitStr(String str) => pleaseWaitStr.value = str;
  void updatestopStr(String str) => stopStr.value = str;
  void updateviewLogStr(String str) => viewLogStr.value = str;
  void updateupdateStr(String str) => updateStr.value = str;
  void updatedownloadingStr(String str) => downloadingStr.value = str;
  void updatedownloadedStr(String str) => downloadedStr.value = str;
  void updateinstallingStr(String str) => installingStr.value = str;
  void updateinstallationCompletedStr(String str) =>
      installationCompletedStr.value = str;
  void updatenotAvaliableStr(String str) => notAvaliableStr.value = str;

  void loadTranslationsFromFile(String path) {
    File translationsFile = File(path);
    String readAsStringSync = '';
    try {
      readAsStringSync = translationsFile.readAsStringSync();
    } catch (e) {
      if (e is FileSystemException) return;
    }
    Map map = json.decode(readAsStringSync);
    updateloadingPageWarningStr(map['loadingPageWarningStr']);
    updatestatusNotRunningStr(map['statusNotRunningStr']);
    updatestartStr(map['startStr']);
    updatestatusInitializingStr(map['statusInitializingStr']);
    updatestatusStartingStr(map['statusStartingStr']);
    updatestatusRunningStr(map['statusRunningStr']);
    updatestatusRunningWithTorStr(map['statusRunningWithTorStr']);
    updatestatusErrorStr(map['statusErrorStr']);
    updatepleaseWaitStr(map['pleaseWaitStr']);
    updatestopStr(map['stopStr']);
    updateviewLogStr(map['viewLogStr']);
    updateupdateStr(map['updateStr']);
    updatedownloadingStr(map['downloadingStr']);
    updatedownloadedStr(map['downloadedStr']);
    updateinstallingStr(map['installingStr']);
    updateinstallationCompletedStr(map['installationCompletedStr']);
    updatenotAvaliableStr(map['notAvaliableStr']);
  }
}
