// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchasesstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PurchasesStore on _PurchasesStore, Store {
  final _$purchasesAtom = Atom(name: '_PurchasesStore.purchases');

  @override
  ObservableList<String> get purchases {
    _$purchasesAtom.context.enforceReadPolicy(_$purchasesAtom);
    _$purchasesAtom.reportObserved();
    return super.purchases;
  }

  @override
  set purchases(ObservableList<String> value) {
    _$purchasesAtom.context.conditionallyRunInAction(() {
      super.purchases = value;
      _$purchasesAtom.reportChanged();
    }, _$purchasesAtom, name: '${_$purchasesAtom.name}_set');
  }

  final _$consumedPurchasesAtom =
      Atom(name: '_PurchasesStore.consumedPurchases');

  @override
  ObservableList<String> get consumedPurchases {
    _$consumedPurchasesAtom.context.enforceReadPolicy(_$consumedPurchasesAtom);
    _$consumedPurchasesAtom.reportObserved();
    return super.consumedPurchases;
  }

  @override
  set consumedPurchases(ObservableList<String> value) {
    _$consumedPurchasesAtom.context.conditionallyRunInAction(() {
      super.consumedPurchases = value;
      _$consumedPurchasesAtom.reportChanged();
    }, _$consumedPurchasesAtom, name: '${_$consumedPurchasesAtom.name}_set');
  }

  final _$_PurchasesStoreActionController =
      ActionController(name: '_PurchasesStore');

  @override
  void addPurchases(dynamic purchaseIds) {
    final _$actionInfo = _$_PurchasesStoreActionController.startAction();
    try {
      return super.addPurchases(purchaseIds);
    } finally {
      _$_PurchasesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addConsumedPurchases(dynamic purchaseIds) {
    final _$actionInfo = _$_PurchasesStoreActionController.startAction();
    try {
      return super.addConsumedPurchases(purchaseIds);
    } finally {
      _$_PurchasesStoreActionController.endAction(_$actionInfo);
    }
  }
}
