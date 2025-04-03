import 'package:bika/src/api/response/category.dart';
import 'package:bika/src/base/logger.dart';
import 'package:bika/src/theme/color.dart';
import 'package:bika/src/api/search.dart';
import 'package:bika/src/views/comic/list/paged.dart';
import 'package:bika/src/views/comic/rank.dart';
import 'package:bika/src/views/comic/random.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  List<Category>? _categories;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _navItems = [
    {'icon': 'assets/images/category_random.webp', 'title': '随机'},
    {'icon': 'assets/images/category_leaderboard.webp', 'title': '排行榜'},
    {'icon': 'assets/images/category_latest.webp', 'title': '最新'},
  ];

  void refreshCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var c = await SearchPageApi.categories();
      if (c != null) {
        if (mounted) {
          // 过滤掉一些不是分类的
          c.categories = c.categories
              .where(
                  (category) => category.link == null || category.link! == "")
              .toList();
          setState(() {
            _categories = c.categories;
          });
        }
      } else {
        BikaLogger().e('categories is null');
      }
    } catch (e) {
      BikaLogger().e(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    refreshCategories();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // 导航区域
              Container(
                height: 160,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    _navItems.length,
                    (index) => _buildNavItem(
                        _navItems[index]['icon'], _navItems[index]['title']),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Icon(Icons.category,
                    color: AppColors.primaryColor(context), size: 20.0),
                const SizedBox(width: 5),
                Text('分类',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: AppColors.primaryColor(context),
                        fontWeight: FontWeight.normal)),
              ]),
              const SizedBox(height: 10),
            ],
          ),
        ),
        if (_isLoading)
          SliverFillRemaining(child: _buildLoadingPage(context))
        else if (_categories == null)
          SliverFillRemaining(child: _buildErrorPage(context))
        else
          _buildCategories(context),
      ],
    );
  }

  Widget _buildNavItem(String icon, String title) {
    return GestureDetector(
      onTap: () {
        if (title == '排行榜') {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const RankComicPageWidget()),
          );
        } else if (title == '最新') {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const LatestComicListPageWidget()),
          );
        } else if (title == '随机') {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const RandomComicPageWidget()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              icon,
              width: 120,
              height: 120,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryColor(context),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPage(BuildContext context) {
    return Center(
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
    );
  }

  Widget _buildErrorPage(BuildContext context) {
    return Center(
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
    );
  }

  Widget _buildGridItem(BuildContext context, Category category) {
    final imageWidth = MediaQuery.of(context).size.width / 3 - 16;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        CategoryComicListPageWidget(category: category.title)),
              );
            },
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
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.8,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildGridItem(context, _categories![index]),
        childCount: _categories!.length,
      ),
    );
  }
}
