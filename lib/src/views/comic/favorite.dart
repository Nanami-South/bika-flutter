import 'package:bika/src/views/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/api/response/comics.dart';
import 'package:bika/src/api/comics.dart';
import 'package:bika/src/base/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bika/src/views/comic/info.dart';
import 'package:bika/src/theme/color.dart';

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
  SortType _sortType = SortType.dateDescend;
  List<ComicDoc>? _comicDocList;
  List<ComicDoc>? _filteredComicList;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingList = false;
  bool _lastLoadingListError = false;
  int _currentPage = 1;
  int? _maxPages;
  bool _showFilter = false;
  String? _selectedCategory;
  String? _selectedAuthor;
  List<String> _uniqueCategories = [];
  List<String> _uniqueAuthors = [];

  void fetchNextPage() async {
    if (_isLoadingList) {
      return;
    }
    if (_maxPages != null && _currentPage > _maxPages!) {
      // 没有更多内容了
      return;
    }
    setState(() {
      _isLoadingList = true;
      _lastLoadingListError = false;
    });
    try {
      final c = await ComicsApi.myLatestFavoriteComics(
          sortType: _sortType, page: _currentPage.toString());
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
            // 更新过滤后的列表
            _updateFilteredList();
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
      _lastLoadingListError = true;
      GlobalToast.show("加载失败，可能是网络问题",
          debugMessage: "$_currentPage/$_maxPages, ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingList = false;
        });
      }
    }
  }

  void _updateFilteredList() {
    if (_comicDocList == null) return;

    _filteredComicList = _comicDocList!.where((comic) {
      bool categoryMatch = _selectedCategory == null ||
          (comic.categories != null &&
              comic.categories!.contains(_selectedCategory));
      bool authorMatch =
          _selectedAuthor == null || comic.author == _selectedAuthor;
      return categoryMatch && authorMatch;
    }).toList();
  }

  void _onFilterChanged() {
    setState(() {
      _updateFilterOptions();
      _updateFilteredList();
    });
  }

  void _onSortTypeChanged(SortType? newValue) {
    if (newValue != null && newValue != _sortType) {
      setState(() {
        _sortType = newValue;
        _comicDocList = null;
        _currentPage = 1;
        _maxPages = null;
      });
      fetchNextPage();
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor(context),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              DropdownButton<SortType>(
                value: _sortType,
                underline: const SizedBox(),
                items: [SortType.dateDescend, SortType.dateAscend]
                    .map((SortType type) {
                  return DropdownMenuItem<SortType>(
                    value: type,
                    child: Text(type.display()),
                  );
                }).toList(),
                onChanged: _onSortTypeChanged,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                    _showFilter ? Icons.filter_list : Icons.filter_list_off),
                onPressed: () {
                  setState(() {
                    _showFilter = !_showFilter;
                    if (_showFilter) {
                      _updateFilterOptions();
                    }
                  });
                },
              ),
            ],
          ),
        ),
        if (_showFilter)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: '选择分类',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('全部分类'),
                    ),
                    ..._uniqueCategories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                    _onFilterChanged();
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedAuthor,
                  decoration: const InputDecoration(
                    labelText: '选择作者',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('全部作者'),
                    ),
                    ..._uniqueAuthors.map((author) {
                      return DropdownMenuItem(
                        value: author,
                        child: Text(author),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedAuthor = value;
                    });
                    _onFilterChanged();
                  },
                ),
              ],
            ),
          ),
        Expanded(
          child: _buildComicCardList(context),
        ),
      ],
    );
  }

  Widget _buildComicCardList(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: (_filteredComicList?.length ?? 0) + 1,
      itemBuilder: (context, index) {
        if (index >= (_filteredComicList?.length ?? 0)) {
          if (!_isLoadingList && _lastLoadingListError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("加载失败，可能是网络问题"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _lastLoadingListError = false;
                      });
                      fetchNextPage();
                    },
                    child: const Text("重试"),
                  ),
                ],
              ),
            );
          }
          if (_isLoadingList) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  Text(
                    "正在加载第 $_currentPage 页...",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }

        return buildComicListCard(context, _filteredComicList![index]);
      },
    );
  }

  void _updateFilterOptions() {
    if (_comicDocList == null) return;

    final categories = <String>{};
    final authors = <String>{};

    for (var comic in _comicDocList!) {
      if (comic.categories != null) {
        categories.addAll(comic.categories!);
      }
      if (comic.author != null && comic.author!.isNotEmpty) {
        authors.add(comic.author!);
      }
    }

    setState(() {
      _uniqueCategories = categories.toList()..sort();
      _uniqueAuthors = authors.toList()..sort();
    });
  }
}
