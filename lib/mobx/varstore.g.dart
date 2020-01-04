// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'varstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$VarStore on _VarStore, Store {
  final _$eventAtom = Atom(name: '_VarStore.event');

  @override
  ObservableEvent get event {
    _$eventAtom.context.enforceReadPolicy(_$eventAtom);
    _$eventAtom.reportObserved();
    return super.event;
  }

  @override
  set event(ObservableEvent value) {
    _$eventAtom.context.conditionallyRunInAction(() {
      super.event = value;
      _$eventAtom.reportChanged();
    }, _$eventAtom, name: '${_$eventAtom.name}_set');
  }

  final _$zeroNetStatusAtom = Atom(name: '_VarStore.zeroNetStatus');

  @override
  String get zeroNetStatus {
    _$zeroNetStatusAtom.context.enforceReadPolicy(_$zeroNetStatusAtom);
    _$zeroNetStatusAtom.reportObserved();
    return super.zeroNetStatus;
  }

  @override
  set zeroNetStatus(String value) {
    _$zeroNetStatusAtom.context.conditionallyRunInAction(() {
      super.zeroNetStatus = value;
      _$zeroNetStatusAtom.reportChanged();
    }, _$zeroNetStatusAtom, name: '${_$zeroNetStatusAtom.name}_set');
  }

  final _$zeroNetInstalledAtom = Atom(name: '_VarStore.zeroNetInstalled');

  @override
  bool get zeroNetInstalled {
    _$zeroNetInstalledAtom.context.enforceReadPolicy(_$zeroNetInstalledAtom);
    _$zeroNetInstalledAtom.reportObserved();
    return super.zeroNetInstalled;
  }

  @override
  set zeroNetInstalled(bool value) {
    _$zeroNetInstalledAtom.context.conditionallyRunInAction(() {
      super.zeroNetInstalled = value;
      _$zeroNetInstalledAtom.reportChanged();
    }, _$zeroNetInstalledAtom, name: '${_$zeroNetInstalledAtom.name}_set');
  }

  final _$zeroNetDownloadedAtom = Atom(name: '_VarStore.zeroNetDownloaded');

  @override
  bool get zeroNetDownloaded {
    _$zeroNetDownloadedAtom.context.enforceReadPolicy(_$zeroNetDownloadedAtom);
    _$zeroNetDownloadedAtom.reportObserved();
    return super.zeroNetDownloaded;
  }

  @override
  set zeroNetDownloaded(bool value) {
    _$zeroNetDownloadedAtom.context.conditionallyRunInAction(() {
      super.zeroNetDownloaded = value;
      _$zeroNetDownloadedAtom.reportChanged();
    }, _$zeroNetDownloadedAtom, name: '${_$zeroNetDownloadedAtom.name}_set');
  }

  final _$loadingStatusAtom = Atom(name: '_VarStore.loadingStatus');

  @override
  String get loadingStatus {
    _$loadingStatusAtom.context.enforceReadPolicy(_$loadingStatusAtom);
    _$loadingStatusAtom.reportObserved();
    return super.loadingStatus;
  }

  @override
  set loadingStatus(String value) {
    _$loadingStatusAtom.context.conditionallyRunInAction(() {
      super.loadingStatus = value;
      _$loadingStatusAtom.reportChanged();
    }, _$loadingStatusAtom, name: '${_$loadingStatusAtom.name}_set');
  }

  final _$loadingPercentAtom = Atom(name: '_VarStore.loadingPercent');

  @override
  int get loadingPercent {
    _$loadingPercentAtom.context.enforceReadPolicy(_$loadingPercentAtom);
    _$loadingPercentAtom.reportObserved();
    return super.loadingPercent;
  }

  @override
  set loadingPercent(int value) {
    _$loadingPercentAtom.context.conditionallyRunInAction(() {
      super.loadingPercent = value;
      _$loadingPercentAtom.reportChanged();
    }, _$loadingPercentAtom, name: '${_$loadingPercentAtom.name}_set');
  }

  final _$_VarStoreActionController = ActionController(name: '_VarStore');

  @override
  void setObservableEvent(ObservableEvent eve) {
    final _$actionInfo = _$_VarStoreActionController.startAction();
    try {
      return super.setObservableEvent(eve);
    } finally {
      _$_VarStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setZeroNetStatus(String status) {
    final _$actionInfo = _$_VarStoreActionController.startAction();
    try {
      return super.setZeroNetStatus(status);
    } finally {
      _$_VarStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void isZeroNetInstalled(bool installed) {
    final _$actionInfo = _$_VarStoreActionController.startAction();
    try {
      return super.isZeroNetInstalled(installed);
    } finally {
      _$_VarStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void isZeroNetDownloaded(bool downloaded) {
    final _$actionInfo = _$_VarStoreActionController.startAction();
    try {
      return super.isZeroNetDownloaded(downloaded);
    } finally {
      _$_VarStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoadingStatus(String status) {
    final _$actionInfo = _$_VarStoreActionController.startAction();
    try {
      return super.setLoadingStatus(status);
    } finally {
      _$_VarStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoadingPercent(int percent) {
    final _$actionInfo = _$_VarStoreActionController.startAction();
    try {
      return super.setLoadingPercent(percent);
    } finally {
      _$_VarStoreActionController.endAction(_$actionInfo);
    }
  }
}
