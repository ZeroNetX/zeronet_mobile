import 'dart:convert';
import 'dart:io';

import 'package:zeronet/core/site/site.dart';

class SiteManager {
  List<Site> loadSitesFromFile(File file) {
    Map<String, dynamic> content = json.decode(file.readAsStringSync());
    List<Site> sites = [];
    for (var item in content.keys) {
      sites.add(
        Site.fromJson(content[item])..address = item,
      );
    }
    return sites;
  }
}
