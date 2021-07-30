import 'dart:ui';

import 'package:get/get.dart';
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
                              'ZeroNet Mobile is a full native client for ZeroNet, a platform for decentralized websites using Bitcoin ',
                              style: GoogleFonts.roboto(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Text.rich(
                        TextSpan(
                          text:
                              'crypto and the BitTorrent network. you can learn more about ZeroNet at ',
                          style: GoogleFonts.roboto(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
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
                      'Contribute',
                      style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                    ),
                    Text(
                      "If you want to support project's further development, you can contribute your time or money, If you want to contribute money you can send bitcoin or other supported crypto currencies to above addresses or buy in-app purchases, if want to contribute translations or code, visit official GitHub repo.",
                      style: GoogleFonts.roboto(
                        fontSize: 18.0,
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
          'Donation Addresses',
          style: GoogleFonts.roboto(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
        ),
        LayoutBuilder(
          builder: (ctx, cons) {
            List<Widget> children = [];
            for (var crypto in donationsAddressMap.keys) {
              children.add(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crypto,
                      style: GoogleFonts.roboto(
                        fontSize: 16.0,
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
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$crypto Donation Address Copied to Clipboard',
                            ),
                          ),
                        );
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
            "* Click on Address to copy",
            style: GoogleFonts.roboto(
              fontSize: 16.0,
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
            "* Any Donation can activate all pro-features in app, "
            "these are just an encouragement to me to work more on the app. "
            "Pro-features will be made available to general public after certain time, "
            "thus you don't need to worry about exclusiveness of a feature. "
            "If you donate from any source other than Google Play Purchase, "
            "just send your transaction id to canews.in@gmail.com / ZeroMail: zeromepro, "
            "so than I can send activation code to activate pro-features.",
            style: GoogleFonts.roboto(
              fontSize: 16.0,
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
          'Developers',
          style: GoogleFonts.roboto(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
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
                                ),
                              ),
                              LayoutBuilder(builder: (context, cons) {
                                List<Widget> children = [];
                                final iconsPath = 'assets/icons';
                                List<String> assets = [
                                  '$iconsPath/github_dark.png',
                                  '$iconsPath/twitter_dark.png',
                                  '$iconsPath/facebook_dark.png',
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
              text: 'Google Play Purchases ',
              children: [
                TextSpan(
                  text: '(30% taken by Google) :',
                  style: GoogleFonts.roboto(
                    fontSize: 14.0,
                  ),
                ),
              ],
              style: GoogleFonts.roboto(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Obx(() {
            List<Widget> mChildren = [];
            Map<String, List<Package>> googlePurchasesTypes = {
              'One Time': purchasesStore.oneTimePurchases,
              'Monthly Subscriptions': purchasesStore.subscriptions,
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
                      label = 'Tip';
                      c = Color(0xFF06CAB6);
                      break;
                    case 1:
                      label = 'Coffee';
                      c = Color(0xFF0696CA);
                      break;
                    case 2:
                      label = 'Lunch';
                      c = Color(0xFFCA067B);
                      break;
                    default:
                  }
                  children.add(
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
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
                      color: c,
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
