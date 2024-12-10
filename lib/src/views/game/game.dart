import 'package:bika/src/theme/color.dart';
import 'package:flutter/material.dart';

class GameWidget extends StatefulWidget {
  static const String routeName = '/game';
  const GameWidget({super.key});

  @override
  State<GameWidget> createState() => GameWidgetState();
}

class GameWidgetState extends State<GameWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor(context),
        surfaceTintColor: AppColors.backgroundColor(context),
      ),
      backgroundColor: AppColors.backgroundColor(context),
      body: const Text('Game page body'),
    );
  }
}
