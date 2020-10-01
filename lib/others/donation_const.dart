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
