// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uistore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UiStore on _UiStore, Store {
  final _$appUpdateAtom = Atom(name: '_UiStore.appUpdate');

  @override
  AppUpdate get appUpdate {
    _$appUpdateAtom.context.enforceReadPolicy(_$appUpdateAtom);
    _$appUpdateAtom.reportObserved();
    return super.appUpdate;
  }

  @override
  set appUpdate(AppUpdate value) {
    _$appUpdateAtom.context.conditionallyRunInAction(() {
      super.appUpdate = value;
      _$appUpdateAtom.reportChanged();
    }, _$appUpdateAtom, name: '${_$appUpdateAtom.name}_set');
  }

  final _$oneTimePurchasesAtom = Atom(name: '_UiStore.oneTimePurchases');

  @override
  ObservableList<ProductDetails> get oneTimePurchases {
    _$oneTimePurchasesAtom.context.enforceReadPolicy(_$oneTimePurchasesAtom);
    _$oneTimePurchasesAtom.reportObserved();
    return super.oneTimePurchases;
  }

  @override
  set oneTimePurchases(ObservableList<ProductDetails> value) {
    _$oneTimePurchasesAtom.context.conditionallyRunInAction(() {
      super.oneTimePurchases = value;
      _$oneTimePurchasesAtom.reportChanged();
    }, _$oneTimePurchasesAtom, name: '${_$oneTimePurchasesAtom.name}_set');
  }

  final _$subscriptionsAtom = Atom(name: '_UiStore.subscriptions');

  @override
  ObservableList<ProductDetails> get subscriptions {
    _$subscriptionsAtom.context.enforceReadPolicy(_$subscriptionsAtom);
    _$subscriptionsAtom.reportObserved();
    return super.subscriptions;
  }

  @override
  set subscriptions(ObservableList<ProductDetails> value) {
    _$subscriptionsAtom.context.conditionallyRunInAction(() {
      super.subscriptions = value;
      _$subscriptionsAtom.reportChanged();
    }, _$subscriptionsAtom, name: '${_$subscriptionsAtom.name}_set');
  }

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

  final _$reloadAtom = Atom(name: '_UiStore.reload');

  @override
  int get reload {
    _$reloadAtom.context.enforceReadPolicy(_$reloadAtom);
    _$reloadAtom.reportObserved();
    return super.reload;
  }

  @override
  set reload(int value) {
    _$reloadAtom.context.conditionallyRunInAction(() {
      super.reload = value;
      _$reloadAtom.reportChanged();
    }, _$reloadAtom, name: '${_$reloadAtom.name}_set');
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
  set currentAppRoute(AppRoute value) {
    _$currentAppRouteAtom.context.conditionallyRunInAction(() {
      super.currentAppRoute = value;
      _$currentAppRouteAtom.reportChanged();
    }, _$currentAppRouteAtom, name: '${_$currentAppRouteAtom.name}_set');
  }

  final _$currentThemeAtom = Atom(name: '_UiStore.currentTheme');

  @override
  AppTheme get currentTheme {
    _$currentThemeAtom.context.enforceReadPolicy(_$currentThemeAtom);
    _$currentThemeAtom.reportObserved();
    return super.currentTheme;
  }

  @override
  set currentTheme(AppTheme value) {
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
  set zeroNetStatus(ZeroNetStatus value) {
    _$zeroNetStatusAtom.context.conditionallyRunInAction(() {
      super.zeroNetStatus = value;
      _$zeroNetStatusAtom.reportChanged();
    }, _$zeroNetStatusAtom, name: '${_$zeroNetStatusAtom.name}_set');
  }

  final _$_UiStoreActionController = ActionController(name: '_UiStore');

  @override
  void updateInAppUpdateAvailable(AppUpdate available) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.updateInAppUpdateAvailable(available);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addOneTimePuchases(List<ProductDetails> details) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.addOneTimePuchases(details);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addSubscriptions(List<ProductDetails> details) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.addSubscriptions(details);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

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
  void updateReload(int i) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.updateReload(i);
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
  void updateCurrentAppRoute(AppRoute appRoute) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.updateCurrentAppRoute(appRoute);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTheme(AppTheme theme) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.setTheme(theme);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setZeroNetStatus(ZeroNetStatus status) {
    final _$actionInfo = _$_UiStoreActionController.startAction();
    try {
      return super.setZeroNetStatus(status);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }
}
