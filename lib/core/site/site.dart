import 'dart:convert';

import 'dart:io';

class Site {
  String address;
  String addressHash;
  String addressSha1;
  String addressShort;
  int added;
  String ajaxKey;
  String authKey;
  int bytesRecv;
  int bytesSent;
  Cache cache;
  int downloaded;
  int modified;
  int optionalDownloaded;
  Map<String, dynamic> optionalHelp;
  bool own;
  int peers;
  List<String> permissions;
  bool serving;
  int size;
  int sizeFilesOptional;
  int sizeOptional;
  String wrapperKey;

  Site({
    this.address,
    this.addressHash,
    this.addressSha1,
    this.addressShort,
    this.added,
    this.ajaxKey,
    this.authKey,
    this.bytesRecv,
    this.bytesSent,
    this.cache,
    this.downloaded,
    this.modified,
    this.optionalDownloaded,
    this.optionalHelp,
    this.own = false,
    this.peers,
    this.permissions,
    this.serving = true,
    this.size,
    this.sizeFilesOptional,
    this.sizeOptional,
    this.wrapperKey,
  });

  Site pause() {
    return this..serving = false;
  }

  Site resume() {
    return this..serving = true;
  }

  Site.fromJson(Map<String, dynamic> jsonStr) {
    added = jsonStr['added']?.toInt();
    ajaxKey = jsonStr['ajax_key'];
    authKey = jsonStr['auth_key'];
    bytesRecv = jsonStr['bytes_recv'];
    bytesSent = jsonStr['bytes_sent'];
    cache = jsonStr['cache'] != null ? Cache.fromJson(jsonStr['cache']) : null;
    downloaded = jsonStr['downloaded']?.toInt();
    modified = jsonStr['modified']?.toInt();
    optionalDownloaded = jsonStr['optional_downloaded'];
    optionalHelp = jsonStr['optional_help'] != null
        ? json.decode(jsonStr['optional_help'])
        : null;
    own = jsonStr['own'];
    peers = jsonStr['peers'];
    permissions = jsonStr['permissions'].cast<String>();
    serving = jsonStr['serving'];
    size = jsonStr['size'];
    sizeFilesOptional = jsonStr['size_files_optional'];
    sizeOptional = jsonStr['size_optional'];
    wrapperKey = jsonStr['wrapper_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added'] = this.added;
    data['ajax_key'] = this.ajaxKey;
    data['auth_key'] = this.authKey;
    data['bytes_recv'] = this.bytesRecv;
    data['bytes_sent'] = this.bytesSent;
    if (this.cache != null) {
      data['cache'] = this.cache.toJson();
    }
    data['downloaded'] = this.downloaded;
    data['modified'] = this.modified;
    data['optional_downloaded'] = this.optionalDownloaded;
    if (this.optionalHelp != null) {
      data['optional_help'] = json.encode(this.optionalHelp);
    }
    data['own'] = this.own;
    data['peers'] = this.peers;
    data['permissions'] = this.permissions;
    data['serving'] = this.serving;
    data['size'] = this.size;
    data['size_files_optional'] = this.sizeFilesOptional;
    data['size_optional'] = this.sizeOptional;
    data['wrapper_key'] = this.wrapperKey;
    return data;
  }
}

class Cache {
  Map<String, dynamic> badFiles;
  dynamic hashfield;
  Map<String, dynamic> piecefields;

  Cache({
    this.badFiles,
    this.hashfield,
    this.piecefields,
  });

  Cache.fromJson(Map<String, dynamic> jsonStr) {
    badFiles = jsonStr['bad_files'] != null ? jsonStr['bad_files'] : null;
    hashfield = jsonStr['hashfield'];
    piecefields =
        jsonStr['piecefields'] != null ? jsonStr['piecefields'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.badFiles != null) {
      data['bad_files'] = this.badFiles;
    }
    data['hashfield'] = this.hashfield;
    if (this.piecefields != null) {
      data['piecefields'] = this.piecefields;
    }
    return data;
  }
}

extension SiteFileSystemExt on Site {
  Site fromFile(File file) {
    return Site.fromJson(json.decode(file.readAsStringSync()));
  }
}
