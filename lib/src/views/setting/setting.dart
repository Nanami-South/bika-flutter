import 'package:bika/src/theme/color.dart';
import 'package:flutter/material.dart';

class SettingWidget extends StatefulWidget {
  static const String routeName = '/setting';
  const SettingWidget({super.key});

  @override
  State<SettingWidget> createState() => SettingWidgetState();
}

class SettingWidgetState extends State<SettingWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
        backgroundColor: bgColor(context),
        surfaceTintColor: bgColor(context),
      ),
      backgroundColor: bgColor(context),
      body: const Text('Setting page body'),
    );
  }
}
