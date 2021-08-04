import 'package:purchases_flutter/purchases_flutter.dart';

import '../imports.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        uiStore.updateCurrentAppRoute(AppRoute.Home);
        return Future.value(false);
      },
      child: Container(
        color: uiStore.currentTheme.value.primaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(24)),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZeroNetAppBar(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          width: 100.0,
                          height: 100.0,
                        ),
                        Padding(padding: const EdgeInsets.all(8.0)),
                        Flexible(
                          child: Container(
                            child: Text(
                              strController.aboutAppDesStr.value,
                              style: GoogleFonts.roboto(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                color:
                                    uiStore.currentTheme.value.primaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Text.rich(
                        TextSpan(
                          text: strController.aboutAppDes1Str.value,
                          style: GoogleFonts.roboto(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: uiStore.currentTheme.value.primaryTextColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'https://zeronet.io/',
                              style: GoogleFonts.roboto(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                color: Color(0xFF8663FF),
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launch('https://zeronet.io/');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                    ),
                    DeveloperWidget(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    DonationWidget(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Text(
                      strController.contributeStr.value,
                      style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: uiStore.currentTheme.value.primaryTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                    ),
                    Text(
                      strController.contributeDesStr.value,
                      style: GoogleFonts.roboto(
                        fontSize: 18.0,
                        color: uiStore.currentTheme.value.primaryTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DonationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strController.donationAddrsStr.value,
          style: GoogleFonts.roboto(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: uiStore.currentTheme.value.primaryTextColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
        ),
        LayoutBuilder(
          builder: (ctx, cons) {
            List<Widget> children = [];
            for (var crypto in donationsAddressMap.keys) {
              var enabled = true;
              if (crypto == 'Liberapay') {
                if (!enableExternalDonations) enabled = false;
              }
              if (enabled)
                children.add(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crypto,
                        style: GoogleFonts.roboto(
                          fontSize: 16.0,
                          color: uiStore.currentTheme.value.primaryTextColor,
                        ),
                      ),
                      ClickableTextWidget(
                        text: donationsAddressMap[crypto],
                        textStyle: GoogleFonts.roboto(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: Color(0xFF8663FF),
                          decoration: TextDecoration.underline,
                        ),
                        onClick: () {
                          FlutterClipboard.copy(donationsAddressMap[crypto]);
                          Get.showSnackbar(GetBar(
                            message: '$crypto '
                                '${strController.donAddrCopiedStr.value}',
                          ));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                      )
                    ],
                  ),
                );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            );
          },
        ),
        Flexible(
          child: Text(
            strController.clickAddrToCopyStr.value,
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              color: uiStore.currentTheme.value.primaryTextColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        if (kEnableInAppPurchases) GooglePlayInAppPurchases(),
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        Flexible(
          child: Text(
            strController.donationDes.value,
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              color: uiStore.currentTheme.value.primaryTextColor,
            ),
          ),
        )
      ],
    );
  }
}

class DeveloperWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strController.developersStr.value,
          style: GoogleFonts.roboto(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: uiStore.currentTheme.value.primaryTextColor,
          ),
        ),
        Padding(padding: const EdgeInsets.all(4.0)),
        LayoutBuilder(
          builder: (ctx, cons) {
            List<Widget> children = [];
            for (var developer in appDevelopers) {
              children.add(
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4.0,
                  color: uiStore.currentTheme.value.cardBgColor,
                  child: Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                                ExactAssetImage(developer.profileIconLink),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                developer.name + '(${developer.developerType})',
                                style: GoogleFonts.roboto(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: uiStore
                                      .currentTheme.value.primaryTextColor,
                                ),
                              ),
                              LayoutBuilder(builder: (context, cons) {
                                List<Widget> children = [];
                                final iconsPath = 'assets/icons';
                                List<String> assets = [
                                  '$iconsPath/github${uiStore.currentTheme.value == AppTheme.Light ? '_dark' : ''}.png',
                                  '$iconsPath/twitter${uiStore.currentTheme.value == AppTheme.Light ? '_dark' : ''}.png',
                                  '$iconsPath/facebook${uiStore.currentTheme.value == AppTheme.Light ? '_dark' : ''}.png',
                                ];
                                List<String> links = [
                                  developer.githubLink,
                                  developer.twitterLink,
                                  developer.facebookLink,
                                ];
                                for (var item in assets) {
                                  children.add(InkWell(
                                    onTap: () {
                                      var i = assets.indexOf(item);
                                      launch(links[i]);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Image.asset(
                                        item,
                                        height: 30.0,
                                        width: 30.0,
                                      ),
                                    ),
                                  ));
                                }
                                return Row(
                                  children: children,
                                );
                              })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: children,
            );
          },
        ),
      ],
    );
  }
}

class GooglePlayInAppPurchases extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: strController.googlePurchasesStr.value,
              children: [
                TextSpan(
                  text: strController.googleFeeWarningStr.value,
                  style: GoogleFonts.roboto(
                    fontSize: 14.0,
                    color: uiStore.currentTheme.value.primaryTextColor,
                  ),
                ),
              ],
              style: GoogleFonts.roboto(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: uiStore.currentTheme.value.primaryTextColor,
              ),
            ),
          ),
          Obx(() {
            List<Widget> mChildren = [];
            Map<String, List<Package>> googlePurchasesTypes = {
              strController.oneTimeSubStr.value:
                  purchasesStore.oneTimePurchases,
              strController.monthlySubStr.value: purchasesStore.subscriptions,
            };
            for (var item in googlePurchasesTypes.keys) {
              List<Package> purchases = googlePurchasesTypes[item];
              purchases
                ..sort((item1, item2) {
                  int item1I1 = item1.identifier.lastIndexOf('_') + 1;
                  int item1I2 = item1.identifier.lastIndexOf('.');
                  String item1PriceStr =
                      item1.identifier.substring(item1I1, item1I2);
                  int item1Price = int.parse(item1PriceStr);
                  int item2I1 = item2.identifier.lastIndexOf('_') + 1;
                  int item2I2 = item2.identifier.lastIndexOf('.');
                  String item2PriceStr =
                      item2.identifier.substring(item2I1, item2I2);
                  int item2Price = int.parse(item2PriceStr);
                  return item1Price < item2Price ? -1 : 1;
                });
              if (purchases.length > 0) {
                List<Widget> children = [];
                for (var package in purchases) {
                  var i = purchases.indexOf(package);
                  Color c = Color(0xFF);
                  String label = '';
                  switch (i) {
                    case 0:
                      label = strController.tipStr.value;
                      c = Color(0xFF06CAB6);
                      break;
                    case 1:
                      label = strController.coffeeStr.value;
                      c = Color(0xFF0696CA);
                      break;
                    case 2:
                      label = strController.lunchStr.value;
                      c = Color(0xFFCA067B);
                      break;
                    default:
                  }
                  children.add(
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(c),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 8.0,
                          bottom: 8.0,
                        ),
                        child: Text(
                          "$label(${package.product.priceString})",
                          style: GoogleFonts.roboto(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () => purchasePackage(package),
                    ),
                  );
                }
                mChildren.add(
                  Column(
                    children: [
                      Padding(padding: const EdgeInsets.all(8.0)),
                      Text(
                        item,
                        style: GoogleFonts.roboto(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(padding: const EdgeInsets.all(8.0)),
                      Center(
                        child: Wrap(
                          spacing: 25.0,
                          runSpacing: 10.0,
                          alignment: WrapAlignment.spaceEvenly,
                          children: children,
                        ),
                      )
                    ],
                  ),
                );
              }
            }
            return Column(
              children: mChildren,
            );
          })
        ],
      ),
    );
  }
}
