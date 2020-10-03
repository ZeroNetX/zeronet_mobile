import 'package:mobx/mobx.dart';

import '../imports.dart';

// Include generated file
part 'purchasesstore.g.dart';

// This is the class used by rest of your codebase
final purchasesStore = PurchasesStore();

class PurchasesStore = _PurchasesStore with _$PurchasesStore;

// The store-class
abstract class _PurchasesStore with Store {
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
