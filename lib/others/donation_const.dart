import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../imports.dart';

const Map<String, String> donationsAddressMap = {
  "BTC(Preferred)": "1eVStCWqLM7hFB1enaoGzAt7T3tsAB41z",
  "ETH": "0xa81a32dcce8e5bcb9792daa19ae7f964699ee536",
  "UPI(Indian Users)": "pramukesh@upi",
  "Liberapay": "https://liberapay.com/canews.in/donate",
};

const Set<String> kGooglePlayPurchaseOneTimeIds = {
  'zeronet_one_1.00',
  'zeronet_one_5.00',
  'zeronet_one_15.00'
};

const Set<String> kGooglePlayPurchaseSubscriptionIds = {
  'zeronet_sub_1.00',
  'zeronet_sub_5.00',
  'zeronet_sub_15.00'
};

Future getInAppPurchases() async {
  Offerings offerings = await Purchases.getOfferings();
  if (offerings.current != null) {
    var onetimePurchases = (offerings.current.availablePackages.where(
      (element) => element.identifier.contains('zeronet_one'),
    )).toList();
    purchasesStore.addOneTimePuchases(onetimePurchases);

    var subscriptions = (offerings.current.availablePackages.where(
      (element) => element.identifier.contains('zeronet_sub'),
    )).toList();
    purchasesStore.addSubscriptions(subscriptions);
  }
}

Future<bool> isProUser() async {
  try {
    final userName = getZeroIdUserName();
    PurchaserInfo purchaserInfo;
    if (userName.isNotEmpty)
      purchaserInfo = (await Purchases.logIn(userName)).purchaserInfo;
    purchaserInfo = await Purchases.getPurchaserInfo();
    if (purchaserInfo.entitlements.active.length > 0) return true;
  } on PlatformException catch (e) {
    printOut(e);
    // Error fetching purchaser info
  }
  return false;
}

void purchasePackage(Package package) async {
  try {
    PurchaserInfo purchaserInfo;
    final userName = getZeroIdUserName();
    if (userName.isNotEmpty)
      purchaserInfo = (await Purchases.logIn(userName)).purchaserInfo;
    purchaserInfo = await Purchases.purchasePackage(package);

    var isPro = await isProUser();
    if (isPro) {
      // Unlock that great "pro" content
    }
    print(purchaserInfo);
  } on PlatformException catch (e) {
    var errorCode = PurchasesErrorHelper.getErrorCode(e);
    if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
      // showError(e);
    }
  }
}

void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
  purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      // showPendingUI();
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        //!TODO Improve Error Messages sp that user can understand easily.
        Get.showSnackbar(
          GetBar(
            title: "Purchase Error",
            message: 'PurchaseStatus.error :: ${purchaseDetails.error.message}',
          ),
        );
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          deliverProduct(purchaseDetails);
        } else {
          // _handleInvalidPurchase(purchaseDetails);
          return;
        }
      }

      if (purchaseDetails.productID != null &&
          purchaseDetails.productID.contains('zeronet_one')) {
        await InAppPurchase.instance
            .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>()
            .consumePurchase(purchaseDetails);
        purchasesStore.addConsumedPurchases(purchaseDetails.purchaseID);
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  });
}

_verifyPurchase(PurchaseDetails purchaseDetails) {
  print(purchaseDetails.verificationData.localVerificationData);
  return Future<bool>.value(true);
}

void deliverProduct(PurchaseDetails purchaseDetails) async {
  // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
  if (purchaseDetails.productID.contains('zeronet_one')) {
    purchasesStore.addPurchases(purchaseDetails.purchaseID);
  } else {}
}
