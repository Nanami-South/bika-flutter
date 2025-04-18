import 'package:bika/src/theme/color.dart';
import 'package:flutter/material.dart';

class NoticeWidget extends StatefulWidget {
  static const String routeName = '/notice';
  const NoticeWidget({super.key});

  @override
  State<NoticeWidget> createState() => NoticeWidgetState();
}

class NoticeWidgetState extends State<NoticeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice'),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor(context),
        surfaceTintColor: AppColors.backgroundColor(context),
      ),
      backgroundColor: AppColors.backgroundColor(context),
      body: const Text('Notice page body'),
    );
  }
}
