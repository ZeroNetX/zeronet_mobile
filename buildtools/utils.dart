import 'dart:io';

main(List<String> args) {
  String arg = args[0];
  switch (arg) {
    case 'modules':
      modules();
      break;
    case 'nonpy':
      removeNonPy();
      break;
    default:
  }
}

var totalFilesList = [];
var nonPyFiles = [];
var pyFiles = [];
var pyLibDir = '\\lib\\python3.8';
removeNonPy() {
  Directory dir = Directory.current;
  //Here
  recursiveHelper(Directory(dir.path + pyLibDir));
  String nonPy = '';
  nonPyFiles.forEach((f) => nonPy = nonPy + f + '\n');

  File f = File('files-nonpy');
  if (f.existsSync()) f.deleteSync();
  f.createSync();
  f.writeAsStringSync(nonPy);

  print(totalFilesList.length);
  print(pyFiles.length);
  print(nonPyFiles.length);
}

List<String> ls = [
  'config-3.8',
  'test',
  'tests',
  'ensurepip',
  'idle_test',
];

recursiveHelper(Directory dir) {
  for (var file in dir.listSync()) {
    if (file is File) {
      var filePath = file.path.replaceAll(dir.path + '\\', '');
      totalFilesList.add(filePath);
      if (filePath.endsWith('.py') || filePath.endsWith('.so')) {
        print('Python file $filePath');
        pyFiles.add(filePath);
      } else {
        print('Non Python file $filePath');
        if (filePath.endsWith('.exe') ||
            filePath.endsWith('.bat') ||
            filePath.endsWith('.ps1')) {
          print("Deleting File at:" + filePath);
          nonPyFiles.add(filePath);
          file.deleteSync(recursive: true);
        } else {
          print("Orphan File at " + filePath);
        }
      }
    } else {
      for (var item in ls) {
        if (file.path.endsWith('\\$item')) {
          file.deleteSync(recursive: true);
        } else {
          recursiveHelper(file);
        }
      }
    }
  }
}

modules() {
  Directory dir = Directory.current;
  File module = File('modules');
  String modules = module.readAsStringSync();
  List<String> validModules = [];
  modules.split('\n').forEach((f) {
    if (f.contains('usr/')) {
      var i = f.indexOf('usr/');
      validModules.add(f.substring(i + 4).replaceAll('/', '\\'));
    }
  });
  var totalFilesList = [];
  var deletedFilesList = [];
  var pyLibDir = '\\lib\\python3.8';
  for (var file in Directory(dir.path + pyLibDir).listSync(recursive: true)) {
    if (file is File) {
      var filePath = file.path.replaceAll(dir.path + '\\', '');
      totalFilesList.add(filePath);
      if (validModules.indexOf(filePath) == -1) {
        print('deleting ${file.path}');
        deletedFilesList.add(filePath);
        file.deleteSync(recursive: false);
      }
    }
  }
  String deleted = '';
  deletedFilesList.forEach((f) => deleted = deleted + f + '\n');

  File f = File('modules-deleted');
  if (f.existsSync()) f.deleteSync();
  f.createSync();
  f.writeAsStringSync(deleted);

  deleteEmptyDirs(dir, pyLibDir);
  deleteEmptyDirs(dir, pyLibDir);
  print(totalFilesList.length);
  // print(totalFilesList[0]);
  print(validModules.length);
  // print(validModules[0]);
  print(deletedFilesList.length);
  // print(deletedFilesList[0]);
}

deleteEmptyDirs(Directory dir, String pyLibDir) {
  print('Deleting Empty Dirs');
  for (var file in Directory(dir.path + pyLibDir).listSync(recursive: true)) {
    if (file is Directory) {
      if (file.listSync(recursive: true).length == 0) {
        file.deleteSync(recursive: true);
      }
    }
  }
}
