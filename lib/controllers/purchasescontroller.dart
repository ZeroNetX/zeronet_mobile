import 'package:purchases_flutter/purchases_flutter.dart' as purchases_flutter;
import '../imports.dart';

final purchasesStore = Get.put(PurchaseController());

class PurchaseController extends GetxController {
  var oneTimePurchases = <purchases_flutter.Package>[].obs;

  var subscriptions = <purchases_flutter.Package>[].obs;

  void addOneTimePuchases(List<purchases_flutter.Package> details) {
    details.forEach((item) {
      bool exists = oneTimePurchases
          .any((element) => element.identifier == item.identifier);
      if (!exists) {
        oneTimePurchases.add(item);
      }
    });
  }

  void addSubscriptions(List<purchases_flutter.Package> details) {
    details.forEach((item) {
      bool exists =
          subscriptions.any((element) => element.identifier == item.identifier);
      if (!exists) {
        subscriptions.add(item);
      }
    });
  }

  var purchases = <String>[].obs;

  void addPurchases(String purchaseIds) {
    if (!purchases.contains(purchaseIds)) {
      purchases.add(purchaseIds);
    }
  }

  var consumedPurchases = <String>[].obs;

  void addConsumedPurchases(String purchaseIds) {
    if (!consumedPurchases.contains(purchaseIds)) {
      consumedPurchases.add(purchaseIds);
    }
  }
}
