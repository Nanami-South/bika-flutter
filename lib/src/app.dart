import 'package:flutter/material.dart';
import 'package:bika/src/account/views/login.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Widget _home;

  @override
  void initState() {
    super.initState();
    _home = const LoginScoffoldWidget();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Bika Flutter', home: _home);
  }
}
