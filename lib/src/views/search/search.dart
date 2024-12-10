import 'package:bika/src/theme/color.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  static const String routeName = '/search';
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
        backgroundColor: bgColor(context),
        surfaceTintColor: bgColor(context),
      ),
      backgroundColor: bgColor(context),
      body: const Text('Search page body'),
    );
  }
}
