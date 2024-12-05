import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user.dart';

const String prefUserInfoKey = 'prefs.userInfo';

class Account with ChangeNotifier {
  Account._internal();

  static final Account shared = Account._internal();
  factory Account() => shared;

  late SharedPreferences _prefs;

  User? _currentUserInfo;
  User? get currentUserInfo => _currentUserInfo;
  set currentUserInfo(User? user) {
    _currentUserInfo = user;
    if (user != null) {
      _prefs.setString(prefUserInfoKey, json.encode(user));
    } else {
      _prefs.remove(prefUserInfoKey);
    }
    notifyListeners();
  }

  Future<void> init() async {
    // read init account info from prefs file
    _prefs = await SharedPreferences.getInstance();
    final userJson = _prefs.getString(prefUserInfoKey);
    if (userJson != null) {
      _currentUserInfo = User.fromJson(json.decode(userJson));
    }
  }
}
