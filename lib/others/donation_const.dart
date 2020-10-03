import 'package:zeronet/mobx/purchasesstore.dart';

import '../imports.dart';

const Map<String, String> donationsAddressMap = {
  "BTC(Preferred)": "35NgjpB3pzkdHkAPrNh2EMERGxnXgwCb6G",
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

Future<List<ProductDetails>> getGooglePlaySubscriptions() async {
  if (kDebugMode) {
    return [
      ProductDetails(
        id: 'zeronet_one_1.00',
        title: 'One Time Purchase.',
        description: 'ZeroNet Mobile Pro Features.',
        price: '\$1.00',
      ),
      ProductDetails(
        id: 'zeronet_one_15.00',
        title: 'One Time Purchase.',
        description: 'ZeroNet Mobile Pro Features.',
        price: '\$15.00',
      ),
      ProductDetails(
        id: 'zeronet_one_5.00',
        title: 'One Time Purchase.',
        description: 'ZeroNet Mobile Pro Features.',
        price: '\$5.00',
      ),
    ];
  } else {
    final ProductDetailsResponse response = await InAppPurchaseConnection
        .instance
        .queryProductDetails(kGooglePlayPurchaseSubscriptionIds);
    if (response.notFoundIDs.isNotEmpty) {
      print(response.notFoundIDs);
    }
    return response.productDetails;
  }
}

Future<List<ProductDetails>> getGooglePlayOneTimePurchases() async {
  if (kDebugMode) {
    return [
      ProductDetails(
        id: 'zeronet_one_1.00',
        title: 'One Time Purchase.',
        description: 'ZeroNet Mobile Pro Features.',
        price: '\$1.00',
      ),
      ProductDetails(
        id: 'zeronet_one_15.00',
        title: 'One Time Purchase.',
        description: 'ZeroNet Mobile Pro Features.',
        price: '\$15.00',
      ),
      ProductDetails(
        id: 'zeronet_one_5.00',
        title: 'One Time Purchase.',
        description: 'ZeroNet Mobile Pro Features.',
        price: '\$5.00',
      ),
    ];
  } else {
    final ProductDetailsResponse response = await InAppPurchaseConnection
        .instance
        .queryProductDetails(kGooglePlayPurchaseOneTimeIds);
    if (response.notFoundIDs.isNotEmpty) {
      print(response.notFoundIDs);
    }
    return response.productDetails;
  }
}

void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
  print('purchaseDetailsList');
  print(purchaseDetailsList);
  purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      // showPendingUI();
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        // handleError(purchaseDetails.error);
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          deliverProduct(purchaseDetails);
        } else {
          // _handleInvalidPurchase(purchaseDetails);
          return;
        }
      }
      print('purchaseDetails.productID');
      print(purchaseDetails.productID);
      if (purchaseDetails.productID.contains('zeronet_one')) {
        await InAppPurchaseConnection.instance.consumePurchase(purchaseDetails);
        purchasesStore.addConsumedPurchases(purchaseDetails.purchaseID);
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchaseConnection.instance
            .completePurchase(purchaseDetails);
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
