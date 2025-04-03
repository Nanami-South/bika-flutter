import 'package:bika/src/api/comics.dart';
import 'package:bika/src/theme/color.dart';
import 'package:bika/src/views/comic/info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/api/response/comics.dart';
import 'package:bika/src/base/logger.dart';
import 'package:bika/src/views/comic/list/paged.dart';
import 'package:flutter/cupertino.dart';

class FavoriteComicsPreviewWidget extends StatefulWidget {
  const FavoriteComicsPreviewWidget({super.key});

  @override
  State<FavoriteComicsPreviewWidget> createState() =>
      _FavoriteComicsPreviewWidgetState();
}

class _FavoriteComicsPreviewWidgetState
    extends State<FavoriteComicsPreviewWidget> {
  PagedComics? _page1stComics;
  bool _isLoading = false;

  void refreshFavouriteComics() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final c = await ComicsApi.myLatestFavoriteComics(
          sortType: SortType.dateDescend, page: "1");
      if (c != null) {
        if (mounted) {
          setState(() {
            _page1stComics = c.comics;
          });
        }
      } else {
        BikaLogger().e('favorite comics is null');
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
    refreshFavouriteComics();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // 顶部 bar
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => FavoriteComicListPageWidget(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(Icons.favorite, color: AppColors.primaryColor(context)),
              const SizedBox(width: 8),
              const Text(
                "已收藏",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                "${_page1stComics?.total ?? 0}", // 收藏列表总数
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
      if (_isLoading)
        _buildLoading(context)
      else if (_page1stComics == null)
        _buildError(context)
      else
        _buildFavouriteComicsPreview(context),
    ]);
  }

  Widget _buildLoading(BuildContext context) {
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

  Widget _buildError(BuildContext context) {
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
                refreshFavouriteComics();
              },
              child: Text('点击重试',
                  style: TextStyle(
                      color: AppColors.primaryColor(context), fontSize: 16)))
        ],
      ),
    );
  }

  Widget _buildComicPreviewCard(
      BuildContext context, String comicId, String coverUrl, String title) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ComicInfoPageWidget(comicId: comicId),
          ),
        )
      },
      child: SizedBox(
        width: 90,
        child: Column(
          children: [
            // 封面图
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: coverUrl,
                width: 90,
                height: 120,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 50),
                fadeOutDuration: const Duration(milliseconds: 50),
                placeholder: (context, url) => Container(
                  width: 90,
                  height: 120,
                  color: Colors.white, // 纯白背景
                  child: const Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 90,
                  height: 120,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // 标题
            SizedBox(
              height: 48,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black87,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavouriteComicsPreview(BuildContext context) {
    if (_page1stComics == null || _page1stComics!.docs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Text("收藏夹里空空如也"),
      );
    }

    final displayItems = _page1stComics!.docs.take(5).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        children: displayItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: _buildComicPreviewCard(
              context,
              item.id,
              item.thumb.imageUrl(),
              item.title,
            ),
          );
        }).toList(),
      ),
    );
  }
}
