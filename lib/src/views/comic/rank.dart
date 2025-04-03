import 'package:flutter/material.dart';

class RankComicPageWidget extends StatefulWidget {
  const RankComicPageWidget({super.key});

  @override
  State<RankComicPageWidget> createState() => _RankComicPageWidgetState();
}

class _RankComicPageWidgetState extends State<RankComicPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("排行榜"),
      ),
    );
  }
}
