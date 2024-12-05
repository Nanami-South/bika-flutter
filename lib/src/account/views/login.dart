import 'package:bika/src/api/login.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/theme/color.dart';

class LoginScoffoldWidget extends StatelessWidget {
  const LoginScoffoldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: bgColor(context),
        surfaceTintColor: bgColor(context),
      ),
      backgroundColor: bgColor(context),
      body: const LoginWidget(),
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
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

  Widget _buildUsernameInputWidget(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(labelText: 'Username'),
    );
  }

  Widget _buildPasswordInputWidget(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(labelText: 'Password'),
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
                print('login tapped');
                await LoginApi.login("username", "password");
                setState(() {
                  _loginButtonBusy = false;
                });
              },
        child: const Text("login"));
  }
}
