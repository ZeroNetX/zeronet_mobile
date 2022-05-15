import '../imports.dart';

abstract class Setting {
  String? name;
  String? description;
  bool? hidden = false;
  Setting({
    this.name,
    this.description,
    this.hidden,
  });

  Map toMap();

  String toJson();

  Setting fromJson(Map<String, dynamic> map);
}

class ToggleSetting extends Setting {
  String? name;
  String? description;
  bool? value;

  ToggleSetting({
    this.name,
    this.description,
    this.value,
    bool hidden = false,
  }) : super(
          name: name,
          description: description,
          hidden: hidden,
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

  String toString() => json.encode(this.toMap());

  void onChanged(bool value) async {
    var map = varStore.settings;
    var key = this.name;
    (map[this.name] as ToggleSetting)..value = value;
    Map<String?, Setting?> m = {};
    map.keys.forEach((k) {
      m[k] = map[k];
    });
    if (key == batteryOptimisation && value) {
      final isOptimised = await (isBatteryOptimised() as FutureOr<bool>);
      (m[key] as ToggleSetting)
        ..value = (!isOptimised) ? await askBatteryOptimisation() : true;
    } else if (key == publicDataFolder) {
      String str = 'data_dir = ${value ? appPrivDir!.path : zeroNetDir}/data';
      writeZeroNetConf(str);
    } else if (key == enableZeroNetFilters) {
      if (value) {
        activateFilters();
      } else {
        deactivateFilters();
      }
    }
    saveSettings(m);
    varStore.updateSetting(
      (map[key] as ToggleSetting)..value = (m[key] as ToggleSetting).value,
    );
  }
}

class MapSetting extends Setting {
  String? name;
  String? description;
  Map? map;
  List<MapOptions>? options;

  MapSetting({
    this.name,
    this.description,
    this.map,
    this.options,
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

  String toString() => json.encode(this.toMap());
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

// ignore: must_be_immutable
class SiteInfo extends Equatable {
  String? address;
  int? peers;
  int? size;
  int? files;
  DateTime? siteAdded;
  DateTime? siteModified;
  bool? serving;
  DateTime? siteCodeUpdated;
  SiteInfo({
    this.address = '',
    this.peers = 0,
    this.size = 0,
    this.files = 0,
    this.serving = false,
    this.siteAdded,
    this.siteModified,
    this.siteCodeUpdated,
  });

  @override
  List<Object?> get props => [
        address,
        peers,
        serving,
        size,
        files,
        siteAdded,
        siteModified,
        siteCodeUpdated,
      ];

  List<String> get propStrings => [
        'address',
        'peers',
        'serving',
        'size',
        'files',
        'siteAdded',
        'siteModified',
        'siteCodeUpdated',
      ];

  SiteInfo fromJson(String jsonMap) {
    Map map = json.decode(jsonMap)['result'];
    return SiteInfo(
      address: map['address'],
      peers: map['peers'],
      serving: map['settings']['serving'],
      size: map['settings']['size'],
      files: map['content']['files'],
      siteAdded:
          DateTime.fromMillisecondsSinceEpoch(map['settings']['added'] * 1000),
      siteModified: DateTime.fromMillisecondsSinceEpoch(
          map['settings']['downloaded'] * 1000),
      siteCodeUpdated: DateTime.fromMillisecondsSinceEpoch(
          map['settings']['modified'] * 1000),
    );
  }

  SiteInfo fromSite(Site site) {
    return SiteInfo(
      address: site.address,
      peers: site.peers,
      serving: site.serving,
      size: site.size,
      siteAdded: site.added != null
          ? DateTime.fromMillisecondsSinceEpoch(site.added! * 1000)
          : null,
      siteModified: site.downloaded != null
          ? DateTime.fromMillisecondsSinceEpoch(site.downloaded! * 1000)
          : null,
      siteCodeUpdated: site.modified != null
          ? DateTime.fromMillisecondsSinceEpoch(site.modified! * 1000)
          : null,
    );
  }
}

class AppDeveloper extends Equatable {
  final String? name;
  final String? profileIconLink;
  final String? developerType;
  final String? githubLink;
  final String? facebookLink;
  final String? twitterLink;
  const AppDeveloper({
    this.name,
    this.profileIconLink,
    this.developerType,
    this.githubLink,
    this.facebookLink,
    this.twitterLink,
  });

  @override
  List<Object?> get props => [
        name,
        profileIconLink,
        developerType,
        githubLink,
        facebookLink,
        twitterLink,
      ];
}
