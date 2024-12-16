import 'package:bika/src/api/response/category.dart';
import 'package:bika/src/base/logger.dart';
import 'package:bika/src/theme/color.dart';
import 'package:bika/src/api/search.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  List<Category>? _categories;
  bool _isLoading = false;

  void refreshCategories() async {
    setState(() {
      _isLoading = true;
    });
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    refreshCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Icon(Icons.leaderboard,
            color: AppColors.primaryColor(context), size: 20.0),
        const SizedBox(width: 5),
        Text('热门分类',
            style: TextStyle(
                fontSize: 20.0,
                color: AppColors.primaryColor(context),
                fontWeight: FontWeight.normal)),
      ]),
      const SizedBox(height: 10),
      if (_isLoading)
        _buildLoadingPage(context)
      else if (_categories == null)
        _buildErrorPage(context)
      else
        _buildCategories(context),
    ]);
  }

  Widget _buildLoadingPage(BuildContext context) {
    return Expanded(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryColor(context),
          ),
          const SizedBox(height: 10),
          const Text('加载中...',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    ));
  }

  Widget _buildErrorPage(BuildContext context) {
    return Expanded(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          const Text('网络请求失败',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 10),
          TextButton(
              onPressed: () {
                refreshCategories();
              },
              child: Text('点击重试',
                  style: TextStyle(
                      color: AppColors.primaryColor(context), fontSize: 16)))
        ],
      ),
    ));
  }

  Widget _buildGridItem(BuildContext context, Category category) {
    final imageWidth = MediaQuery.of(context).size.width / 3 - 16;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            imageUrl: category.coverUrl,
            width: imageWidth,
            height: imageWidth,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 50),
            fadeOutDuration: const Duration(milliseconds: 50),
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor(context),
                  strokeWidth: 1,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
                width: imageWidth,
                height: imageWidth,
                color: Colors.grey[200],
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, color: Colors.grey),
                  ],
                )),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          category.title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryColor(context),
              fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildCategories(BuildContext context) {
    // 热门分类
    return Expanded(
        child: Column(children: [
      Expanded(
          child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 每行3列
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.8,
        ),
        itemCount: _categories?.length ?? 0,
        itemBuilder: (context, index) {
          return _buildGridItem(context, _categories![index]);
        },
      ))
    ]));
  }
}
