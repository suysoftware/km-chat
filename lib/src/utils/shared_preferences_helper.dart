import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  StreamController<String> streamController = StreamController<String>.broadcast();

  Future<void> addNewUnreadUser(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usersList = prefs.getStringList("unread_users");

    if (usersList == null) {
      prefs.setStringList("unread_users", [value]);
      streamController.add("unread_users");
    } else {
      if (usersList.contains(value) == false) {
        usersList.add(value);
        prefs.setStringList("unread_users", usersList);
        streamController.add("unread_users");
      }
    }
  }

  Future<void> cleanUnreadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usersList = prefs.getStringList("unread_users");

    if (usersList != null) {
      prefs.setStringList("unread_users", []);
    }
  }

  Future<void> removeUnreadUser(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usersList = prefs.getStringList("unread_users");

    if (usersList != null) {
      if (usersList.contains(value)) {
        usersList.remove(value);
        prefs.setStringList("unread_users", usersList);
        streamController.add("unread_users");
      }
    }
  }

  Future<List<String>?> getUnreadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usersList = prefs.getStringList("unread_users");

    return usersList;
  }

  Stream<String> get onDataChanged => streamController.stream;
}
