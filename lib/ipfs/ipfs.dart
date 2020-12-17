import '../imports.dart';

class IPFS {
  Future<ProcessResult> run(
    File libFile,
    String ipfsPath,
    List<String> cmds,
  ) {
    return Process.run(
      libFile.path,
      cmds,
      environment: {
        "IPFS_PATH": ipfsPath,
      },
    );
  }

  ProcessResult runSync(
    File libFile,
    String ipfsPath,
    List<String> cmds,
  ) {
    return Process.runSync(
      libFile.path,
      cmds,
      environment: {
        "IPFS_PATH": ipfsPath,
      },
    );
  }

  init(
    File libFile,
    String ipfsPath,
  ) {
    runSync(libFile, ipfsPath, ['init']);
  }
}
