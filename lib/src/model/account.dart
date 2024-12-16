import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bika/src/base/logger.dart';
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

enum AccountEvent {
  login,
  logout,
}

const String prefUserInfoKey = 'prefs.account';

class Account with ChangeNotifier {
  Account._internal();
  static final Account shared = Account._internal();
  factory Account() => shared;

  // 用来通知一些组件账号登出事件，暂停掉一些定时操作
  final accountEventController = StreamController<AccountEvent>.broadcast();

  late SharedPreferences _prefs;

  AccountData? _currentAccount;
  AccountData? get currentAccount => _currentAccount;
  set currentAccount(AccountData? account) {
    // 登陆登出的时候，会调用这个方法, 保存当前账号信息
    _currentAccount = account;
    if (account != null) {
      _prefs.setString(prefUserInfoKey, json.encode(account));
    } else {
      // 新的账户信息为空认为是退出登录，删除之前的账户信息
      _prefs.remove(prefUserInfoKey);
    }
    notifyListeners();
  }

  Future<void> init() async {
    // App启动的时候，尝试从本地获取之前的账户登陆状态信息
    _prefs = await SharedPreferences.getInstance();
    final accountDataJson = _prefs.getString(prefUserInfoKey);
    if (accountDataJson != null) {
      _currentAccount = AccountData.fromJson(json.decode(accountDataJson));
      if (kDebugMode) {
        BikaLogger().d(
            'init account: name=${_currentAccount?.userName}, password=${_currentAccount?.password}, token=${_currentAccount?.token}');
      }
    }
  }

  bool isValidLogin() {
    // 检查是否有token
    if (_currentAccount == null) {
      return false;
    }
    return _currentAccount!.token != null && _currentAccount!.token!.isNotEmpty;
  }

  void login(AccountData account) {
    currentAccount = account;
    accountEventController.add(AccountEvent.login);
  }

  void logout() {
    currentAccount = null;
    accountEventController.add(AccountEvent.logout);
  }

  @override
  void dispose() {
    accountEventController.close();
    super.dispose();
  }
}
