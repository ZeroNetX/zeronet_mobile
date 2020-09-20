import 'dart:convert';
import 'dart:io';

import 'package:zeronet/core/user/user.dart';

class UserManager {
  List<User> loadUsersFromFile(File file) {
    List<User> users = [];
    Map usersFileData = json.decode(file.readAsStringSync());
    for (var user in usersFileData.keys) {
      users.add(User.fromJson(usersFileData[user]));
    }
    return users;
  }
}
