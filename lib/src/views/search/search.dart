import 'package:bika/src/api/response/category.dart';
import 'package:bika/src/svc/logger.dart';
import 'package:bika/src/theme/color.dart';
import 'package:bika/src/api/search.dart';
import 'package:flutter/material.dart';

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
  List<Category>? _categories;

  void refreshCategories() async {
    try {
      final c = await SearchPageApi.categories();
      if (c != null) {
        setState(() {
          _categories = c.categories;
        });
      } else {
        BikaLogger().e('categories is null');
      }
    } catch (e) {
      BikaLogger().e(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    // 初始化的时候请求 api 获取数据
    refreshCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分类'),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor(context),
        surfaceTintColor: AppColors.backgroundColor(context),
      ),
      backgroundColor: AppColors.backgroundColor(context),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildCategories(context),
      ]),
    );
  }

  Widget _buildCategories(BuildContext context) {
    // 热门分类
    return Expanded(
        child: Column(children: [
      Row(children: [
        Icon(Icons.category,
            color: AppColors.primaryColor(context), size: 20.0),
        const SizedBox(width: 5),
        Text('热门分类',
            style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primaryColor(context),
                fontWeight: FontWeight.bold)),
      ]),
      const SizedBox(height: 10),
      Expanded(
          child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 每行3列
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: _categories?.length ?? 0,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  _categories![index].coverUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _categories![index].title ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, color: AppColors.primaryColor(context)),
              ),
            ],
          );
        },
      ))
    ]));
  }
}
