import 'package:bika/src/api/login.dart';
import 'package:bika/src/base/logger.dart';
import 'package:bika/src/model/account.dart';
import 'package:bika/src/views/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/theme/color.dart';
import 'package:bika/src/views/register.dart';

class LoginWidget extends StatelessWidget {
  static const String routeName = '/login';
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor(context),
        surfaceTintColor: AppColors.backgroundColor(context),
      ),
      backgroundColor: AppColors.backgroundColor(context),
      body: const LoginBodyWidget(),
    );
  }
}

class LoginBodyWidget extends StatefulWidget {
  const LoginBodyWidget({super.key});

  @override
  State<LoginBodyWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginBodyWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisuable = false;
  bool _loginButtonBusy = false;

  @override
  void initState() {
    super.initState();
    // 从路由参数中获取账号密码
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _usernameController.text = args['username'] ?? '';
        _passwordController.text = args['password'] ?? '';
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {FocusScope.of(context).unfocus()},
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 32),
                _buildUsernameInputWidget(context),
                const SizedBox(height: 16),
                _buildPasswordInputWidget(context),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRegisterButtonWidget(context),
                    const SizedBox(width: 32),
                    _buildLoginButtonWidget(context),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            )));
  }

  Widget _buildUsernameInputWidget(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(labelText: 'Username'),
      controller: _usernameController,
    );
  }

  Widget _buildPasswordInputWidget(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: IconButton(
              icon: _passwordVisuable
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _passwordVisuable = !_passwordVisuable;
                });
              })),
      controller: _passwordController,
      obscureText: !_passwordVisuable,
    );
  }

  Widget _buildRegisterButtonWidget(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      onPressed: () async {
        final result = await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const RegisterWidget(),
          ),
        );
        if (result != null) {
          _usernameController.text = result['username'] ?? '';
          _passwordController.text = result['password'] ?? '';
        }
      },
      child: const Text("注册账号"),
    );
  }

  Widget _buildLoginButtonWidget(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        onPressed: _loginButtonBusy
            ? null
            : () async {
                setState(() {
                  _loginButtonBusy = true;
                });
                try {
                  final username = _usernameController.text;
                  final password = _passwordController.text;
                  if (username.isEmpty || password.isEmpty) {
                    GlobalToast.show("username or password is empty");
                    return;
                  }
                  final token = await LoginApi.login(username, password);
                  final account = AccountData(
                    userName: username,
                    password: password,
                    token: token,
                  );
                  Account.shared.login(account);
                  if (mounted) {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  }
                } catch (e) {
                  if (!mounted) return;
                  BikaLogger().e(e.toString());
                  // toast hint
                  GlobalToast.show("登录失败", debugMessage: e.toString());
                } finally {
                  if (mounted) {
                    setState(() {
                      _loginButtonBusy = false;
                    });
                  }
                }
              },
        child: const Text("登录"));
  }
}
