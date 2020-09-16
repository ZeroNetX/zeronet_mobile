import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as timeAgo;
import 'package:zeronet/mobx/uistore.dart';
import 'package:zeronet/models/models.dart';
import 'package:zeronet/others/common.dart';
import 'package:zeronet/others/constants.dart';
import 'package:zeronet/others/extensions.dart';
import 'package:zeronet/others/zeronet_utils.dart';
import 'package:zeronet_ws/zeronet_ws.dart';

import 'common.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkInitStatus();
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(24)),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Column(
                children: <Widget>[
                  ZeroNetAppBar(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                  ),
                  ZeroNetStatusWidget(),
                  PopularZeroNetSites(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ZeroNetStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Text(
              'Status',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Observer(
              builder: (context) {
                return Chip(
                  label: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      uiStore.zeroNetStatus.message,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  backgroundColor: uiStore.zeroNetStatus.statusChipColor,
                );
              },
            ),
            Spacer(
              flex: 1,
            ),
            Observer(builder: (context) {
              return InkWell(
                onTap: uiStore.zeroNetStatus.onAction,
                child: Chip(
                  label: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      uiStore.zeroNetStatus.actionText,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  backgroundColor: uiStore.zeroNetStatus.actionBtnColor,
                ),
              );
            }),
            if (uiStore.zeroNetStatus == ZeroNetStatus.ERROR)
              Spacer(
                flex: 1,
              ),
            if (uiStore.zeroNetStatus == ZeroNetStatus.ERROR)
              InkWell(
                onTap: ZeroNetStatus.NOT_RUNNING.onAction,
                child: Chip(
                  label: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      ZeroNetStatus.NOT_RUNNING.actionText,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  backgroundColor: ZeroNetStatus.NOT_RUNNING.actionBtnColor,
                ),
              ),
            Spacer(
              flex: 4,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 30),
        )
      ],
    );
  }
}

class PopularZeroNetSites extends StatelessWidget {
  final VoidCallback callback;
  const PopularZeroNetSites({
    Key key,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> zeroSites = [];
    for (var key in Utils.initialSites.keys) {
      var name = key;
      zeroSites.add(
        SiteDetailCard(name: name),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          children: [
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Popular Sites',
                    style: GoogleFonts.roboto(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  height: 3,
                  width: 120,
                  color: Color(0xFF2B2BFF),
                )
              ],
            ),
          ],
        ),
        ListView(
          shrinkWrap: true,
          // crossAxisCount: 2,
          children: zeroSites,
          physics: BouncingScrollPhysics(),
        )
        // wgt,
      ],
    );
  }
}

class SiteDetailCard extends StatelessWidget {
  const SiteDetailCard({
    Key key,
    @required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    bool isZiteExists = isZiteExitsLocally(
      Utils.initialSites[name]['btcAddress'],
    );
    return Card(
      shadowColor: Color(0x52000000),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      margin: EdgeInsets.only(bottom: 14.0),
      child: Container(
        height: 60.0,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 30.0,
            right: 16.5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    name,
                    maxLines: 1,
                    style: GoogleFonts.roboto(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      size: 28,
                      color: Color(0xFF5A53FF),
                    ),
                    onPressed: () {
                      showBottomSheet(
                        context: context,
                        elevation: 16.0,
                        builder: (ctx) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            constraints: BoxConstraints(
                              minHeight: 300.0,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                ),
                                Container(
                                  height: 5.0,
                                  width: 80.0,
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF5A53FF),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SiteDetailsSheet(name),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  InkWell(
                    child: Icon(
                      isZiteExists ? Icons.play_arrow : Icons.file_download,
                      size: 36,
                      color: Color(isZiteExists ? 0xFF6EB69E : 0xDF6EB69E),
                    ),
                    onTap: () {
                      browserUrl = zeroNetUrl + Utils.initialSites[name]['url'];
                      uiStore.updateCurrentAppRoute(AppRoute.ZeroBrowser);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SiteDetailsSheet extends StatelessWidget {
  SiteDetailsSheet(this.name);
  final String name;
  @override
  Widget build(BuildContext context) {
    try {
      ZeroNet.instance.siteInfo(
        callback: (msg) => uiStore.updateCurrentSiteInfo(
          SiteInfo().fromJson(msg),
        ),
      );
    } catch (e) {}
    bool isZiteExists = isZiteExitsLocally(
      Utils.initialSites[name]['btcAddress'],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontSize: 31.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Color(0xFF5A53FF),
                  ),
                  onPressed: () => Share.share(Utils.initialSites[name]['url']),
                ),
                RaisedButton(
                  color: Color(0xFF009764),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  onPressed: () {
                    browserUrl = zeroNetUrl + Utils.initialSites[name]['url'];
                    uiStore.updateCurrentAppRoute(AppRoute.ZeroBrowser);
                  },
                  child: Text(
                    isZiteExists ? 'OPEN' : 'DOWNLOAD',
                    maxLines: 1,
                    style: GoogleFonts.roboto(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        Padding(padding: EdgeInsets.all(6.0)),
        Text(
          Utils.initialSites[name]['description'],
          style: GoogleFonts.roboto(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        Padding(padding: EdgeInsets.all(6.0)),
        Wrap(
          spacing: 16.0,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            RaisedButton(
              color: Color(0xFF008297),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: () {},
              child: Text(
                'Add to HomeScreen',
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ),
            if (isZiteExists)
              RaisedButton(
                color: Color(0xFF517184),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  uiStore.updateCurrentAppRoute(AppRoute.LogPage);
                },
                child: Text(
                  'Show Log',
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
            if (isZiteExists)
              RaisedButton(
                color: Color(0xFF009793),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  //TODO: Implement this function;
                },
                child: Text(
                  'Pause',
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
            if (isZiteExists)
              RaisedButton(
                color: Color(0xFFBB4848),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  //TODO: Implement this function;
                },
                child: Text(
                  'Delete Zite',
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        Padding(padding: EdgeInsets.all(6.0)),
        if (isZiteExists)
          Observer(builder: (context) {
            return SiteInfoWidget(
              uiStore.currentSiteInfo,
            );
          }),
      ],
    );
  }
}

class SiteInfoWidget extends StatelessWidget {
  final SiteInfo siteInfo;
  const SiteInfoWidget(this.siteInfo);
  @override
  Widget build(BuildContext context) {
    List<Widget> infoTitleWgts = [];
    List<Widget> infoWgts = [];
    for (var item in siteInfo.propStrings..remove('files')) {
      final i = siteInfo.propStrings.indexOf(item);
      infoTitleWgts.add(
        Text(
          siteInfo.propStrings[i].inCaps,
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      if (siteInfo.props[i] != null) {
        String details = (siteInfo.props[i] is DateTime)
            ? timeAgo.format(siteInfo.props[i])
            : siteInfo.props[i].toString();
        if (item == 'size') {
          details = ((siteInfo.props[i] as int) ~/ 1000).toString() +
              ' KB ($details Bytes) (' +
              siteInfo.props[siteInfo.propStrings.indexOf('files')].toString() +
              ' Files)';
        } else if (siteInfo.props[i] is DateTime) {
          DateTime t = siteInfo.props[i];
          details = details + ' (${t.day}/${t.month}/${t.year})';
        }
        infoWgts.add(
          Text(
            '  :  ' + details,
            style: GoogleFonts.roboto(
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SiteInfo',
          style: GoogleFonts.roboto(
            fontSize: 21.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(padding: EdgeInsets.all(2.0)),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: []..addAll(infoTitleWgts),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: []..addAll(infoWgts),
            ),
          ],
        )
      ],
    );
  }
}
