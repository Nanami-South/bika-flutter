import 'package:bika/src/views/toast.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/api/response/comics.dart';
import 'package:bika/src/api/comics.dart';
import 'package:bika/src/base/logger.dart';
import 'package:bika/src/theme/color.dart';
import 'package:bika/src/views/comic/list/card.dart';

class PagedComicListWidget extends StatefulWidget {
  final String appbarTitle;
  final List<SortType> availableSortTypes;
  const PagedComicListWidget({
    super.key,
    required this.appbarTitle,
    required this.availableSortTypes,
  });

  @override
  State<PagedComicListWidget> createState() => _PagedComicListWidgetState();

  /// 子类来实现
  Future<PagedComicsListResponseData?> Function(String, SortType)
      get fetchComicsMethod => (page, sortType) async {
            /// 子类需要实现
            return null;
          };
}

class _PagedComicListWidgetState extends State<PagedComicListWidget> {
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
      final c =
          await widget.fetchComicsMethod(_currentPage.toString(), _sortType);
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
        BikaLogger().e('fetch Category comics is null');
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
        title: Text(widget.appbarTitle),
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
                items: widget.availableSortTypes.map((SortType type) {
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

        return ComicListCardWidget(comic: _filteredComicList![index]);
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

/// 收藏列表页面
class FavoriteComicListPageWidget extends PagedComicListWidget {
  const FavoriteComicListPageWidget({super.key})
      : super(
          appbarTitle: "全部收藏",
          availableSortTypes: const [SortType.dateDescend, SortType.dateAscend],
        );

  @override
  Future<PagedComicsListResponseData?> Function(String, SortType)
      get fetchComicsMethod => (page, sortType) async {
            return await ComicsApi.myLatestFavoriteComics(
                sortType: sortType, page: page);
          };
}

/// 作者列表页面
class AuthorComicListPageWidget extends PagedComicListWidget {
  final String author;
  const AuthorComicListPageWidget({super.key, required this.author})
      : super(
          appbarTitle: author,
          availableSortTypes: const [
            SortType.dateDescend,
            SortType.dateAscend,
            SortType.likeDescend,
            SortType.viewDescend,
          ],
        );

  @override
  Future<PagedComicsListResponseData?> Function(String, SortType)
      get fetchComicsMethod => (page, sortType) async {
            return await ComicsApi.comicsWithAuthor(author, page, sortType);
          };
}

/// 分类列表页面
class CategoryComicListPageWidget extends PagedComicListWidget {
  final String category;
  const CategoryComicListPageWidget({super.key, required this.category})
      : super(
          appbarTitle: category,
          availableSortTypes: const [
            SortType.dateDescend,
            SortType.dateAscend,
            SortType.likeDescend,
            SortType.viewDescend,
          ],
        );

  @override
  Future<PagedComicsListResponseData?> Function(String, SortType)
      get fetchComicsMethod => (page, sortType) async {
            return await ComicsApi.comicsWithCategory(category, page, sortType);
          };
}

/// tag 列表页面
class TagComicListPageWidget extends PagedComicListWidget {
  final String tag;
  const TagComicListPageWidget({super.key, required this.tag})
      : super(
          appbarTitle: tag,
          availableSortTypes: const [
            SortType.dateDescend,
            SortType.dateAscend,
            SortType.likeDescend,
            SortType.viewDescend,
          ],
        );

  @override
  Future<PagedComicsListResponseData?> Function(String, SortType)
      get fetchComicsMethod => (page, sortType) async {
            return await ComicsApi.comicsWithTags(tag, page, sortType);
          };
}

/// 汉化组列表页面
class ChineseTeamComicListPageWidget extends PagedComicListWidget {
  final String chineseTeam;
  const ChineseTeamComicListPageWidget({super.key, required this.chineseTeam})
      : super(
          appbarTitle: chineseTeam,
          availableSortTypes: const [
            SortType.dateDescend,
            SortType.dateAscend,
            SortType.likeDescend,
            SortType.viewDescend,
          ],
        );

  @override
  Future<PagedComicsListResponseData?> Function(String, SortType)
      get fetchComicsMethod => (page, sortType) async {
            return await ComicsApi.comicsWithChineseTeam(
                chineseTeam, page, sortType);
          };
}

/// 上传者列表页面
class CreatorComicListPageWidget extends PagedComicListWidget {
  final Creator creator;
  CreatorComicListPageWidget({super.key, required this.creator})
      : super(
          appbarTitle: creator.name,
          availableSortTypes: const [
            SortType.dateDescend,
            SortType.dateAscend,
            SortType.likeDescend,
            SortType.viewDescend,
          ],
        );

  @override
  Future<PagedComicsListResponseData?> Function(String, SortType)
      get fetchComicsMethod => (page, sortType) async {
            return await ComicsApi.comicsWithCreator(
                creator.id, page, sortType);
          };
}

/// 最近更新列表页面
class LatestComicListPageWidget extends PagedComicListWidget {
  const LatestComicListPageWidget({super.key})
      : super(
          appbarTitle: "最近更新",
          availableSortTypes: const [SortType.dateDescend, SortType.dateAscend],
        );

  @override
  Future<PagedComicsListResponseData?> Function(String, SortType)
      get fetchComicsMethod => (page, sortType) async {
            return await ComicsApi.latestComics(page);
          };
}
