import 'package:mobx/mobx.dart';
import 'package:zeronet/models/models.dart';

// Include generated file
part 'varstore.g.dart';

// This is the class used by rest of your codebase
final varStore = VarStore();

class VarStore = _VarStore with _$VarStore;

// The store-class
abstract class _VarStore with Store {
  String zeroNetWrapperKey = '';

  @observable
  ObservableMap<String, Setting> settings = ObservableMap<String, Setting>();

  @action
  void updateSetting(Setting setting) {
    settings.update(setting.name, (sett) {
      return sett;
    }, ifAbsent: () {
      return setting;
    });
  }

  @observable
  ObservableEvent event;

  @action
  void setObservableEvent(ObservableEvent eve) {
    event = eve;
  }

  @observable
  String zeroNetLog = 'ZeroNet Mobile';

  @action
  void setZeroNetLog(String status) {
    zeroNetLog = status;
  }

  @observable
  String zeroNetAppbarStatus = 'ZeroNet Mobile';

  @action
  void setZeroNetAppbarStatus(String status) {
    zeroNetAppbarStatus = status;
  }

  // @observable
  // String zeroNetStatus = 'Not Running';

  // @action
  // void setZeroNetStatus(String status) {
  //   zeroNetStatus = status;
  // }

  @observable
  bool zeroNetInstalled = false;

  @action
  void isZeroNetInstalled(bool installed) {
    zeroNetInstalled = installed;
  }

  @observable
  bool zeroNetDownloaded = false;

  @action
  void isZeroNetDownloaded(bool downloaded) {
    zeroNetDownloaded = downloaded;
  }

  @observable
  String loadingStatus = 'Loading';

  @action
  void setLoadingStatus(String status) {
    loadingStatus = status;
  }

  @observable
  int loadingPercent = 0;

  @action
  void setLoadingPercent(int percent) {
    loadingPercent = percent;
  }
}

enum ObservableEvent { none, downloding, downloaded, installing, installed }
