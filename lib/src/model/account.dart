import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class AccountData {
  String? userName;
  String? password;
  String? token;

  AccountData({
    this.userName,
    this.password,
    this.token,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDataToJson(this);
}

const String prefUserInfoKey = 'prefs.account';

class Account with ChangeNotifier {
  Account._internal();
  static final Account shared = Account._internal();
  factory Account() => shared;

  late SharedPreferences _prefs;

  AccountData? _currentAccount;
  AccountData? get currentAccount => _currentAccount;
  set currentAccount(AccountData? account) {
    // 登陆登出的时候，会调用这个方法, 保存当前账户信息
    _currentAccount = account;
    if (account != null) {
      _prefs.setString(prefUserInfoKey, json.encode(account));
    } else {
      // 新的账户信息为空，则删除之前的账户信息, 一般是退出登录
      _prefs.remove(prefUserInfoKey);
    }
    notifyListeners();
  }

  Future<void> init() async {
    // 尝试从本地获取之前的账户信息
    _prefs = await SharedPreferences.getInstance();
    final accountDataJson = _prefs.getString(prefUserInfoKey);
    if (accountDataJson != null) {
      _currentAccount = AccountData.fromJson(json.decode(accountDataJson));
      print(
          'init account: name=${_currentAccount?.userName}, password=${_currentAccount?.password}, token=${_currentAccount?.token}');
    }
  }
}
