// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uistore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UiStore on _UiStore, Store {
  final _$showSnackReplyAtom = Atom(name: '_UiStore.showSnackReply');

  @override
  bool get showSnackReply {
    _$showSnackReplyAtom.context.enforceReadPolicy(_$showSnackReplyAtom);
    _$showSnackReplyAtom.reportObserved();
    return super.showSnackReply;
  }

  @override
  set showSnackReply(bool value) {
    _$showSnackReplyAtom.context.conditionallyRunInAction(() {
      super.showSnackReply = value;
      _$showSnackReplyAtom.reportChanged();
    }, _$showSnackReplyAtom, name: '${_$showSnackReplyAtom.name}_set');
  }

  final _$currentSiteInfoAtom = Atom(name: '_UiStore.currentSiteInfo');

  @override
  SiteInfo get currentSiteInfo {
    _$currentSiteInfoAtom.context.enforceReadPolicy(_$currentSiteInfoAtom);
    _$currentSiteInfoAtom.reportObserved();
    return super.currentSiteInfo;
  }

  @override
  set currentSiteInfo(SiteInfo value) {
    _$currentSiteInfoAtom.context.conditionallyRunInAction(() {
      super.currentSiteInfo = value;
      _$currentSiteInfoAtom.reportChanged();
    }, _$currentSiteInfoAtom, name: '${_$currentSiteInfoAtom.name}_set');
  }

  final _$currentAppRouteAtom = Atom(name: '_UiStore.currentAppRoute');

  @override
  AppRoute get currentAppRoute {
    _$currentAppRouteAtom.context.enforceReadPolicy(_$currentAppRouteAtom);
    _$currentAppRouteAtom.reportObserved();
    return super.currentAppRoute;
  }

  @override
  set currentAppRoute(dynamic value) {
    _$currentAppRouteAtom.context.conditionallyRunInAction(() {
      super.currentAppRoute = value;
      _$currentAppRouteAtom.reportChanged();
    }, _$currentAppRouteAtom, name: '${_$currentAppRouteAtom.name}_set');
  }

  final _$appBarTitleAtom = Atom(name: '_UiStore.appBarTitle');

  @override
  String get appBarTitle {
    _$appBarTitleAtom.context.enforceReadPolicy(_$appBarTitleAtom);
    _$appBarTitleAtom.reportObserved();
    return super.appBarTitle;
  }

  @override
  set appBarTitle(dynamic value) {
    _$appBarTitleAtom.context.conditionallyRunInAction(() {
      super.appBarTitle = value;
      _$appBarTitleAtom.reportChanged();
    }, _$appBarTitleAtom, name: '${_$appBarTitleAtom.name}_set');
  }

  final _$appBarIconAtom = Atom(name: '_UiStore.appBarIcon');

  @override
  IconData get appBarIcon {
    _$appBarIconAtom.context.enforceReadPolicy(_$appBarIconAtom);
    _$appBarIconAtom.reportObserved();
    return super.appBarIcon;
  }

  @override
  set appBarIcon(IconData value) {
    _$appBarIconAtom.context.conditionallyRunInAction(() {
      super.appBarIcon = value;
      _$appBarIconAtom.reportChanged();
    }, _$appBarIconAtom, name: '${_$appBarIconAtom.name}_set');
  }

  final _$currentThemeAtom = Atom(name: '_UiStore.currentTheme');

  @override
  Theme get currentTheme {
    _$currentThemeAtom.context.enforceReadPolicy(_$currentThemeAtom);
    _$currentThemeAtom.reportObserved();
    return super.currentTheme;
  }

  @override
  set currentTheme(Theme value) {
    _$currentThemeAtom.context.conditionallyRunInAction(() {
      super.currentTheme = value;
      _$currentThemeAtom.reportChanged();
    }, _$currentThemeAtom, name: '${_$currentThemeAtom.name}_set');
  }

  final _$zeroNetStatusAtom = Atom(name: '_UiStore.zeroNetStatus');

  @override
  ZeroNetStatus get zeroNetStatus {
    _$zeroNetStatusAtom.context.enforceReadPolicy(_$zeroNetStatusAtom);
    _$zeroNetStatusAtom.reportObserved();
    return super.zeroNetStatus;
  }

  @override
  set zeroNetStatus(dynamic value) {
    _$zeroNetStatusAtom.context.conditionallyRunInAction(() {
      super.zeroNetStatus = value;
      _$zeroNetStatusAtom.reportChanged();
    }, _$zeroNetStatusAtom, name: '${_$zeroNetStatusAtom.name}_set');
  }

  final _$_UiStoreActionController = ActionController(name: '_UiStore');

  @override
  void updateShowSnackReply(bool show) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.updateShowSnackReply(show);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCurrentSiteInfo(SiteInfo siteInfo) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.updateCurrentSiteInfo(siteInfo);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCurrentAppRoute(dynamic appRoute) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.updateCurrentAppRoute(appRoute);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateAppBarTitle(dynamic title) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.updateAppBarTitle(title);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateAppBarIcon(IconData icon) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.updateAppBarIcon(icon);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTheme(Theme theme) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.setTheme(theme);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setZeroNetStatus(dynamic status) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.setZeroNetStatus(status);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }
}
