import 'package:mobx/mobx.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases_flutter;

// Include generated file
part 'purchasesstore.g.dart';

// This is the class used by rest of your codebase
final purchasesStore = PurchasesStore();

class PurchasesStore = _PurchasesStore with _$PurchasesStore;

// The store-class
abstract class _PurchasesStore with Store {
  @observable
  ObservableList<purchases_flutter.Package> oneTimePurchases =
      ObservableList<purchases_flutter.Package>();

  @observable
  ObservableList<purchases_flutter.Package> subscriptions =
      ObservableList<purchases_flutter.Package>();

  @action
  void addOneTimePuchases(List<purchases_flutter.Package> details) {
    for (var item in details) {
      bool exists = oneTimePurchases
          .any((element) => element.identifier == item.identifier);
      if (!exists) {
        oneTimePurchases.add(item);
      }
    }
  }

  @action
  void addSubscriptions(List<purchases_flutter.Package> details) {
    for (var item in details) {
      bool exists =
          subscriptions.any((element) => element.identifier == item.identifier);
      if (!exists) {
        subscriptions.add(item);
      }
    }
  }

  @observable
  ObservableList<String> purchases = ObservableList();

  @action
  void addPurchases(String purchaseIds) {
    if (!purchases.contains(purchaseIds)) {
      purchases.add(purchaseIds);
    }
  }

  @observable
  ObservableList<String> consumedPurchases = ObservableList();

  @action
  void addConsumedPurchases(String purchaseIds) {
    if (!consumedPurchases.contains(purchaseIds)) {
      consumedPurchases.add(purchaseIds);
    }
  }
}
