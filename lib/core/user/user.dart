import 'dart:convert';

class User {
  Map<String, Cert> certsMap;
  String masterSeed;
  Settings settings;
  Map<String, UserSite> sites;

  User({this.certsMap, this.masterSeed, this.settings, this.sites});

  User.fromJson(Map<String, dynamic> json) {
    certsMap = {};
    if (json['certs'] != null) {
      for (var cert in (json['certs'] as Map).keys) {
        certsMap[cert] = Cert.fromJson((json['certs'] as Map)[cert]);
      }
    }
    masterSeed = json['master_seed'];
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
    sites = {};
    if (json['sites'] != null) {
      for (var site in (json['sites'] as Map).keys) {
        sites[site] = UserSite.fromJson(json['sites'][site]);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.certsMap != null) {
      data['certs'] = json.encode(this.certsMap);
    }
    data['master_seed'] = this.masterSeed;
    if (this.settings != null) {
      data['settings'] = this.settings.toJson();
    }
    if (this.sites != null) {
      data['sites'] = json.encode(this.sites);
    }
    return data;
  }
}

class Settings {
  String theme;
  bool useSystemTheme;

  Settings({this.theme, this.useSystemTheme});

  Settings.fromJson(Map<String, dynamic> json) {
    theme = json['theme'];
    useSystemTheme = json['use_system_theme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['theme'] = this.theme;
    data['use_system_theme'] = this.useSystemTheme;
    return data;
  }
}

class Cert {
  String authAddress;
  String authPrivatekey;
  String authType;
  String authUserName;
  String certSign;

  Cert(
      {this.authAddress,
      this.authPrivatekey,
      this.authType,
      this.authUserName,
      this.certSign});

  Cert.fromJson(Map<String, dynamic> json) {
    authAddress = json['auth_address'];
    authPrivatekey = json['auth_privatekey'];
    authType = json['auth_type'];
    authUserName = json['auth_user_name'];
    certSign = json['cert_sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth_address'] = this.authAddress;
    data['auth_privatekey'] = this.authPrivatekey;
    data['auth_type'] = this.authType;
    data['auth_user_name'] = this.authUserName;
    data['cert_sign'] = this.certSign;
    return data;
  }
}

class UserSite {
  String authAddress;
  String authPrivatekey;
  String encryptPrivatekey0;
  String encryptPublickey0;
  String cert;
  Settings settings;
  Map<String, dynamic> follow;
  String privatekey;

  UserSite(
      {this.authAddress,
      this.authPrivatekey,
      this.encryptPrivatekey0,
      this.encryptPublickey0,
      this.cert,
      this.settings,
      this.follow,
      this.privatekey});

  UserSite.fromJson(Map<String, dynamic> json) {
    authAddress = json['auth_address'];
    authPrivatekey = json['auth_privatekey'];
    encryptPrivatekey0 = json['encrypt_privatekey_0'];
    encryptPublickey0 = json['encrypt_publickey_0'];
    cert = json['cert'];
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
    follow = json['follow'] != null ? json['follow'] : null;
    privatekey = json['privatekey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth_address'] = this.authAddress;
    data['auth_privatekey'] = this.authPrivatekey;
    data['encrypt_privatekey_0'] = this.encryptPrivatekey0;
    data['encrypt_publickey_0'] = this.encryptPublickey0;
    data['cert'] = this.cert;
    if (this.settings != null) {
      data['settings'] = this.settings.toJson();
    }
    if (this.follow != null) {
      data['follow'] = json.encode(this.follow);
    }
    data['privatekey'] = this.privatekey;
    return data;
  }
}

class SiteSettings {
  int dateFeedVisit;
  Map<String, dynamic> favoriteSites;
  Map<String, dynamic> siteblocksIgnore;
  String sitesOrderby;
  Map<String, dynamic> sitesSectionHide;

  SiteSettings(
      {this.dateFeedVisit,
      this.favoriteSites,
      this.siteblocksIgnore,
      this.sitesOrderby,
      this.sitesSectionHide});

  SiteSettings.fromJson(Map<String, dynamic> json) {
    dateFeedVisit = json['date_feed_visit'];
    favoriteSites =
        json['favorite_sites'] != null ? json['favorite_sites'] : null;
    siteblocksIgnore =
        json['siteblocks_ignore'] != null ? json['siteblocks_ignore'] : null;
    sitesOrderby = json['sites_orderby'];
    sitesSectionHide =
        json['sites_section_hide'] != null ? json['sites_section_hide'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_feed_visit'] = this.dateFeedVisit;
    if (this.favoriteSites != null) {
      data['favorite_sites'] = json.encode(this.favoriteSites);
    }
    if (this.siteblocksIgnore != null) {
      data['siteblocks_ignore'] = json.encode(this.siteblocksIgnore);
    }
    data['sites_orderby'] = this.sitesOrderby;
    if (this.sitesSectionHide != null) {
      data['sites_section_hide'] = json.encode(this.sitesSectionHide);
    }
    return data;
  }
}
