import 'package:flutter/material.dart';
import 'package:bika/src/api/response/comics.dart';
import 'package:bika/src/api/comics.dart';
import 'package:bika/src/base/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ComicReaderWidget extends StatefulWidget {
  final String comicId;
  final int episodeId; // 漫画章节ID, 对应接口中的 order
  const ComicReaderWidget(
      {super.key, required this.comicId, required this.episodeId});

  @override
  State<ComicReaderWidget> createState() => _ComicReaderWidgetState();
}

class _ComicReaderWidgetState extends State<ComicReaderWidget> {
  ComicPictureEp? _comicPictureEp;
  final List<ComicPicturePageDoc> _comicPicturePages = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _maxPage = 1;
  final ScrollController _scrollController = ScrollController();

  Future<void> _onScrollChanged() async {
    // BikaLogger().d(
    //     'Scroll position: ${_scrollController.position.pixels}, max: ${_scrollController.position.maxScrollExtent}');

    // 如果已经滚动到底部，直接触发加载
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoading) {
      BikaLogger().d(
          'Triggering next page load, current page: $_currentPage, max page: $_maxPage');
      fetchNextPage(widget.comicId, widget.episodeId);
    }
  }

  void fetchNextPage(String comicId, int episodeId) async {
    if (_currentPage > _maxPage) {
      // no more content
      return;
    }
    if (_isLoading) {
      BikaLogger().d('Already loading, skipping');
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      BikaLogger().d('Fetching page $_currentPage');
      final c = await ComicsApi.comicPictureData(
          comicId, episodeId, _currentPage.toString());
      if (c != null) {
        if (mounted) {
          setState(() {
            _comicPictureEp = c.ep;
            _comicPicturePages.addAll(c.pages.docs);
            _maxPage = c.pages.pages;
            _currentPage++;
            BikaLogger().d('Successfully loaded page, new max page: $_maxPage');
          });
        }
      } else {
        BikaLogger().e('fetch comic picture data is null, id=$comicId');
      }
    } catch (e) {
      BikaLogger().e('Error loading page: ${e.toString()}');
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
    BikaLogger().d('Initializing ComicReaderWidget');
    fetchNextPage(widget.comicId, widget.episodeId);
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
        title: Text(_comicPictureEp?.title ?? "阅读漫画"),
        leading: const BackButton(), // 左上角返回按钮
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_comicPictureEp == null) {
      if (_isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return const Center(child: Text('获取漫画章节数据失败'));
      }
    } else {
      return ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _comicPicturePages.length + 1,
        itemBuilder: (context, index) {
          if (index == _comicPicturePages.length) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('没有更多了'));
            }
          }
          final imageUrl = _comicPicturePages[index].media.imageUrl();
          return Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.fitWidth,
              fadeInDuration: const Duration(milliseconds: 300),
              fadeOutDuration: const Duration(milliseconds: 300),
              placeholder: (context, url) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, color: Colors.grey, size: 40),
                    SizedBox(height: 8),
                    Text('图片加载失败', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
