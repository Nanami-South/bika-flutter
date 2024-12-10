import 'package:bika/src/theme/color.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => ProfileWidgetState();
}

class ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor(context),
        surfaceTintColor: AppColors.backgroundColor(context),
      ),
      backgroundColor: AppColors.backgroundColor(context),
      body: const Text('Profile page body'),
    );
  }
}
