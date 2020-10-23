// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uistore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UiStore on _UiStore, Store {
  final _$appUpdateAtom = Atom(name: '_UiStore.appUpdate');

  @override
  AppUpdate get appUpdate {
    _$appUpdateAtom.reportRead();
    return super.appUpdate;
  }

  @override
  set appUpdate(AppUpdate value) {
    _$appUpdateAtom.reportWrite(value, super.appUpdate, () {
      super.appUpdate = value;
    });
  }

  final _$showSnackReplyAtom = Atom(name: '_UiStore.showSnackReply');

  @override
  bool get showSnackReply {
    _$showSnackReplyAtom.reportRead();
    return super.showSnackReply;
  }

  @override
  set showSnackReply(bool value) {
    _$showSnackReplyAtom.reportWrite(value, super.showSnackReply, () {
      super.showSnackReply = value;
    });
  }

  final _$reloadAtom = Atom(name: '_UiStore.reload');

  @override
  int get reload {
    _$reloadAtom.reportRead();
    return super.reload;
  }

  @override
  set reload(int value) {
    _$reloadAtom.reportWrite(value, super.reload, () {
      super.reload = value;
    });
  }

  final _$currentSiteInfoAtom = Atom(name: '_UiStore.currentSiteInfo');

  @override
  SiteInfo get currentSiteInfo {
    _$currentSiteInfoAtom.reportRead();
    return super.currentSiteInfo;
  }

  @override
  set currentSiteInfo(SiteInfo value) {
    _$currentSiteInfoAtom.reportWrite(value, super.currentSiteInfo, () {
      super.currentSiteInfo = value;
    });
  }

  final _$currentAppRouteAtom = Atom(name: '_UiStore.currentAppRoute');

  @override
  AppRoute get currentAppRoute {
    _$currentAppRouteAtom.reportRead();
    return super.currentAppRoute;
  }

  @override
  set currentAppRoute(AppRoute value) {
    _$currentAppRouteAtom.reportWrite(value, super.currentAppRoute, () {
      super.currentAppRoute = value;
    });
  }

  final _$currentThemeAtom = Atom(name: '_UiStore.currentTheme');

  @override
  AppTheme get currentTheme {
    _$currentThemeAtom.reportRead();
    return super.currentTheme;
  }

  @override
  set currentTheme(AppTheme value) {
    _$currentThemeAtom.reportWrite(value, super.currentTheme, () {
      super.currentTheme = value;
    });
  }

  final _$zeroNetStatusAtom = Atom(name: '_UiStore.zeroNetStatus');

  @override
  ZeroNetStatus get zeroNetStatus {
    _$zeroNetStatusAtom.reportRead();
    return super.zeroNetStatus;
  }

  @override
  set zeroNetStatus(ZeroNetStatus value) {
    _$zeroNetStatusAtom.reportWrite(value, super.zeroNetStatus, () {
      super.zeroNetStatus = value;
    });
  }

  final _$_UiStoreActionController = ActionController(name: '_UiStore');

  @override
  void updateInAppUpdateAvailable(AppUpdate available) {
    final _$actionInfo = _$_UiStoreActionController.startAction(
        name: '_UiStore.updateInAppUpdateAvailable');
    try {
      return super.updateInAppUpdateAvailable(available);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateShowSnackReply(bool show) {
    final _$actionInfo = _$_UiStoreActionController.startAction(
        name: '_UiStore.updateShowSnackReply');
    try {
      return super.updateShowSnackReply(show);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateReload(int i) {
    final _$actionInfo =
        _$_UiStoreActionController.startAction(name: '_UiStore.updateReload');
    try {
      return super.updateReload(i);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCurrentSiteInfo(SiteInfo siteInfo) {
    final _$actionInfo = _$_UiStoreActionController.startAction(
        name: '_UiStore.updateCurrentSiteInfo');
    try {
      return super.updateCurrentSiteInfo(siteInfo);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCurrentAppRoute(AppRoute appRoute) {
    final _$actionInfo = _$_UiStoreActionController.startAction(
        name: '_UiStore.updateCurrentAppRoute');
    try {
      return super.updateCurrentAppRoute(appRoute);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTheme(AppTheme theme) {
    final _$actionInfo =
        _$_UiStoreActionController.startAction(name: '_UiStore.setTheme');
    try {
      return super.setTheme(theme);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setZeroNetStatus(ZeroNetStatus status) {
    final _$actionInfo = _$_UiStoreActionController.startAction(
        name: '_UiStore.setZeroNetStatus');
    try {
      return super.setZeroNetStatus(status);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
appUpdate: ${appUpdate},
showSnackReply: ${showSnackReply},
reload: ${reload},
currentSiteInfo: ${currentSiteInfo},
currentAppRoute: ${currentAppRoute},
currentTheme: ${currentTheme},
zeroNetStatus: ${zeroNetStatus}
    ''';
  }
}
