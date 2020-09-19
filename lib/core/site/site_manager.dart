import 'dart:convert';
import 'dart:io';

import 'package:zeronet/core/site/site.dart';

class SiteManager {
  Map<String, Site> loadSitesFromFile(File file) {
    Map<String, dynamic> content = json.decode(file.readAsStringSync());
    Map<String, Site> sites = {};
    for (var item in content.keys) {
      sites[item] = Site.fromJson(content[item]);
    }
    return sites;
  }

  void saveSettingstoFile(File sitesFile, Map sitesData) {
    if (sitesFile.existsSync()) {
      sitesFile.writeAsStringSync(json.encode(sitesData));
    }
  }
}
