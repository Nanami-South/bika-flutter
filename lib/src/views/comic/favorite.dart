import 'package:bika/src/views/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/api/response/comics.dart';
import 'package:bika/src/api/comics.dart';
import 'package:bika/src/base/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bika/src/views/comic/info.dart';

Widget buildComicListCard(BuildContext context, ComicDoc comic) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ComicInfoPageWidget(comicId: comic.id),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面图
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: CachedNetworkImage(
              imageUrl: comic.thumb.imageUrl(),
              width: 120,
              height: 160,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                width: 120,
                height: 160,
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                width: 120,
                height: 160,
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: SizedBox(
                height: 160 - 16,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          comic.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${comic.pagesCount}P",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                        Text(
                          comic.author ?? "",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.pink),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "分类: ${comic.categories?.join(", ") ?? ""}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black87),
                        ),
                        const Spacer(), // 添加间距弹性填充
                      ],
                    ),
                    Positioned(
                      // 改用绝对定位
                      bottom: 0,
                      left: 0,
                      right: 0,

                      child: Row(
                        children: [
                          const Icon(Icons.favorite,
                              size: 14, color: Colors.pink),
                          const SizedBox(width: 4),
                          Text("${comic.totalLikes}"),
                          const SizedBox(width: 12),
                          Text("指数: ${comic.totalViews}"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class FavoriteComicListPageWidget extends StatefulWidget {
  const FavoriteComicListPageWidget({super.key});

  @override
  State<FavoriteComicListPageWidget> createState() =>
      _FavoriteComicListPageWidgetState();
}

class _FavoriteComicListPageWidgetState
    extends State<FavoriteComicListPageWidget> {
  List<ComicDoc>? _comicDocList;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;
  int? _maxPages;

  void fetchNextPage() async {
    if (_isLoading) {
      return;
    }
    if (_maxPages != null && _currentPage > _maxPages!) {
      // 没有更多内容了
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final c = await ComicsApi.myLatestFavoriteComics(
          sortType: SortType.dateDescend, page: _currentPage.toString());
      if (c != null) {
        if (mounted) {
          setState(() {
            if (_comicDocList == null) {
              _comicDocList = c.comics.docs;
            } else {
              _comicDocList!.addAll(c.comics.docs);
            }
            _currentPage += 1;
            _maxPages = c.comics.pages;
            // 第一次滑到底部给出toast提示
            if (_currentPage > _maxPages!) {
              GlobalToast.show("已经滑到底部啦",
                  debugMessage: "$_currentPage/$_maxPages");
            }
          });
        }
      } else {
        BikaLogger().e('fetch favorite comics is null');
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

  Future<void> _onScrollChanged() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      fetchNextPage();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNextPage();

    _scrollController.addListener(_onScrollChanged);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("全部收藏"),
        leading: const BackButton(), // 左上角返回按钮
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _comicDocList?.length ?? 0,
      itemBuilder: (context, index) {
        if (index >= (_comicDocList?.length ?? 0)) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return buildComicListCard(context, _comicDocList![index]);
      },
    );
  }
}
