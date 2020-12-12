import 'dart:convert';
import 'dart:typed_data';

abstract class Setting {
  String name;
  String description;
  Setting({
    this.name,
    this.description,
  });

  Map toMap();

  String toJson();

  Setting fromJson(Map<String, dynamic> map);
}

class ToggleSetting extends Setting {
  String name;
  String description;
  bool value;

  ToggleSetting({
    this.name,
    this.description,
    this.value,
  }) : super(
          name: name,
          description: description,
        );

  @override
  Map toMap() => {
        'name': name,
        'description': description,
        'value': value,
      };

  @override
  String toJson() => json.encode(this.toMap());

  ToggleSetting fromJson(Map<String, dynamic> map) {
    return ToggleSetting(
      name: map['name'],
      description: map['description'],
      value: map['value'],
    );
  }
}

class MapSetting extends Setting {
  String name;
  String description;
  Map map;

  MapSetting({
    this.name,
    this.description,
    this.map,
  }) : super(
          name: name,
          description: description,
        );

  @override
  Map toMap() => {
        'name': name,
        'description': description,
        'map': map,
      };

  @override
  String toJson() => json.encode(this.toMap());

  MapSetting fromJson(Map<String, dynamic> map) {
    return MapSetting(
      name: map['name'],
      description: map['description'],
      map: map['map'],
    );
  }
}

class Utils {
  static const String urlHello = '1HeLLo4uzjaLetFx6NH3PMwFP3qbRbTf3D';
  static const String urlTalk = 'Talk.ZeroNetwork.bit';
  static const String urlBlog = 'Blog.ZeroNetwork.bit';
  static const String urlMail = 'Mail.ZeroNetwork.bit';
  static const String urlMe = 'Me.ZeroNetwork.bit';
  static const String urlSites = 'Sites.ZeroNetwork.bit';
  static const String urlZeroNetMob = '15UYrA7aXr2Nto1Gg4yWXpY3EAJwafMTNk';

  static const initialSites = const {
    'ZeroHello': {
      'description': 'Hello Zeronet Site',
      'url': urlHello,
    },
    'ZeroMobile': {
      'description': 'Report Android App Issues Here.',
      'url': urlZeroNetMob,
    },
    'ZeroTalk': {
      'description': 'Reddit-like, decentralized forum',
      'url': urlTalk,
    },
    'ZeroBlog': {
      'description': 'Microblogging Platform',
      'url': urlBlog,
    },
    'ZeroMail': {
      'description': 'End-to-End Encrypted Mailing',
      'url': urlMail,
    },
    'ZeroMe': {
      'description': 'P2P Social Network',
      'url': urlMe,
    },
    'ZeroSites': {
      'description': 'Discover More Sites',
      'url': urlSites,
    },
  };

  // 'ZeroName': '1Name2NXVi1RDPDgf5617UoW7xA6YrhM9F',
}

class UnzipParams {
  String item;
  Uint8List bytes;
  String dest;
  UnzipParams(
    this.item,
    this.bytes, {
    this.dest = '',
  });
}

enum state {
  NOT_DOWNLOADED,
  DOWNLOADING,
  NOT_INSTALLED,
  INSTALLING,
  MAKING_AS_EXEC,
  READY,
  RUNNING,
  NONE,
}
