// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchasesstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PurchasesStore on _PurchasesStore, Store {
  final _$oneTimePurchasesAtom = Atom(name: '_PurchasesStore.oneTimePurchases');

  @override
  ObservableList<purchases_flutter.Package> get oneTimePurchases {
    _$oneTimePurchasesAtom.reportRead();
    return super.oneTimePurchases;
  }

  @override
  set oneTimePurchases(ObservableList<purchases_flutter.Package> value) {
    _$oneTimePurchasesAtom.reportWrite(value, super.oneTimePurchases, () {
      super.oneTimePurchases = value;
    });
  }

  final _$subscriptionsAtom = Atom(name: '_PurchasesStore.subscriptions');

  @override
  ObservableList<purchases_flutter.Package> get subscriptions {
    _$subscriptionsAtom.reportRead();
    return super.subscriptions;
  }

  @override
  set subscriptions(ObservableList<purchases_flutter.Package> value) {
    _$subscriptionsAtom.reportWrite(value, super.subscriptions, () {
      super.subscriptions = value;
    });
  }

  final _$purchasesAtom = Atom(name: '_PurchasesStore.purchases');

  @override
  ObservableList<String> get purchases {
    _$purchasesAtom.reportRead();
    return super.purchases;
  }

  @override
  set purchases(ObservableList<String> value) {
    _$purchasesAtom.reportWrite(value, super.purchases, () {
      super.purchases = value;
    });
  }

  final _$consumedPurchasesAtom =
      Atom(name: '_PurchasesStore.consumedPurchases');

  @override
  ObservableList<String> get consumedPurchases {
    _$consumedPurchasesAtom.reportRead();
    return super.consumedPurchases;
  }

  @override
  set consumedPurchases(ObservableList<String> value) {
    _$consumedPurchasesAtom.reportWrite(value, super.consumedPurchases, () {
      super.consumedPurchases = value;
    });
  }

  final _$_PurchasesStoreActionController =
      ActionController(name: '_PurchasesStore');

  @override
  void addOneTimePuchases(List<purchases_flutter.Package> details) {
    final _$actionInfo = _$_PurchasesStoreActionController.startAction(
        name: '_PurchasesStore.addOneTimePuchases');
    try {
      return super.addOneTimePuchases(details);
    } finally {
      _$_PurchasesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addSubscriptions(List<purchases_flutter.Package> details) {
    final _$actionInfo = _$_PurchasesStoreActionController.startAction(
        name: '_PurchasesStore.addSubscriptions');
    try {
      return super.addSubscriptions(details);
    } finally {
      _$_PurchasesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPurchases(String purchaseIds) {
    final _$actionInfo = _$_PurchasesStoreActionController.startAction(
        name: '_PurchasesStore.addPurchases');
    try {
      return super.addPurchases(purchaseIds);
    } finally {
      _$_PurchasesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addConsumedPurchases(String purchaseIds) {
    final _$actionInfo = _$_PurchasesStoreActionController.startAction(
        name: '_PurchasesStore.addConsumedPurchases');
    try {
      return super.addConsumedPurchases(purchaseIds);
    } finally {
      _$_PurchasesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
oneTimePurchases: ${oneTimePurchases},
subscriptions: ${subscriptions},
purchases: ${purchases},
consumedPurchases: ${consumedPurchases}
    ''';
  }
}
