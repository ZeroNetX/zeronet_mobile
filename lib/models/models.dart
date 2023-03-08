import '../imports.dart';

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
