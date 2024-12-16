import 'package:bika/src/theme/color.dart';
import 'package:flutter/material.dart';
import 'category.dart';

class CategoryItem {
  final String? name;
  final String? iconUrl;

  CategoryItem(this.name, this.iconUrl);
}

class SearchWidget extends StatefulWidget {
  static const String routeName = '/search';
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('探索',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor(context))),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor(context),
        surfaceTintColor: AppColors.backgroundColor(context),
      ),
      backgroundColor: AppColors.backgroundColor(context),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: CategoryGrid()), // 热门分类部分
      ]),
    );
  }
}
