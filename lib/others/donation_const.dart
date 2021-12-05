import 'package:purchases_flutter/purchases_flutter.dart';

import '../imports.dart';

var enableExternalDonations = false;
var btcAddress = '1ZeroNetyV5mKY9JF1gsm82TuBXHpfdLX';
var ethAddress = '0xa7064577f79ece591143F5CccBA2afAE057903C6';
var upiAddress = 'pramukesh@upi';
var liberaPayAddress = 'https://liberapay.com/canews.in/donate';

void getDonationSettings() {
  var dir = Utils.urlZeroNetMob.zeroNetDataPath;
  if (Directory(dir).existsSync()) {
    var file = File(dir + '/native.decent');
    if (file.existsSync()) {
      var decode = json.decode(file.readAsStringSync());
      var settingsMap = (decode as Map<String, dynamic>)['settings'];
      var donations = settingsMap['donations'];
      enableExternalDonations = donations['enableExternalDonations'];
      btcAddress = donations['btcAddress'];
      ethAddress = donations['ethAddress'];
      upiAddress = donations['upiAddress'];
      liberaPayAddress = donations['liberapayAddress'];
    }
  }
}

Map<String, String> donationsAddressMap = {
  "BTC(Preferred)": btcAddress,
  "ETH": ethAddress,
  "UPI(Indian Users)": upiAddress,
  "Liberapay": liberaPayAddress,
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
    if (userName.isNotEmpty) {
      purchaserInfo = (await Purchases.logIn(userName)).purchaserInfo;
      purchaserInfo = await Purchases.getPurchaserInfo();
      if (purchaserInfo.entitlements.active.length > 0) return true;
    } else
      return false;
  } on PlatformException catch (e) {
    printOut(e);
    // Error fetching purchaser info
    return false;
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

    kisProUser = await isProUser();
    if (kisProUser) {
      // Unlock that great "pro" content
    }
    printOut(purchaserInfo);
  } on PlatformException catch (e) {
    var errorCode = PurchasesErrorHelper.getErrorCode(e);
    if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
      // showError(e);
    }
  }
}
