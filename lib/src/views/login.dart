import 'package:bika/src/api/login.dart';
import 'package:bika/src/model/account.dart';
import 'package:bika/src/views/toast.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/theme/color.dart';

class LoginWidget extends StatelessWidget {
  static const String routeName = '/login';
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                _buildLoginButtonWidget(context),
              ],
            )));
  }

  final TextEditingController _usernameController =
      TextEditingController(text: Account.shared.currentAccount?.userName);
  final TextEditingController _passwordController =
      TextEditingController(text: Account.shared.currentAccount?.password);
  bool _passwordVisuable = false;

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

  bool _loginButtonBusy = false;
  Widget _buildLoginButtonWidget(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          foregroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
                  // toast hint
                  GlobalToast.show("login failed", debugMessage: e.toString());
                } finally {
                  if (mounted) {
                    setState(() {
                      _loginButtonBusy = false;
                    });
                  }
                }
              },
        child: const Text("login"));
  }
}
