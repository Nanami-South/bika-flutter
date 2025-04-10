import 'package:bika/src/views/comic/reader/reader.dart';
import 'package:bika/src/views/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/api/response/comics.dart';
import 'package:bika/src/api/comics.dart';
import 'package:bika/src/base/logger.dart';
import 'package:bika/src/base/time.dart';

class ComicEpisodeListWidget extends StatefulWidget {
  final String comicId;
  const ComicEpisodeListWidget({super.key, required this.comicId});

  @override
  State<ComicEpisodeListWidget> createState() => _ComicEpisodeListWidgetState();
}

class _ComicEpisodeListWidgetState extends State<ComicEpisodeListWidget> {
  final List<ComicEpisodeDoc> _comicEpisodeList = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPage = 1;
  final ScrollController _scrollController = ScrollController();

  void refreshEpisodeData(String comicId) async {
    if (_currentPage > _totalPage) {
      return;
    }
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final c =
          await ComicsApi.comicEpisodeData(comicId, _currentPage.toString());
      if (c != null) {
        if (mounted) {
          setState(() {
            _comicEpisodeList.addAll(c.eps.docs);
            _totalPage = c.eps.pages;
            _currentPage = _currentPage + 1;
          });
        }
      } else {
        BikaLogger().e('fetch comic episode data is null, id=$comicId');
      }
    } catch (e) {
      BikaLogger().e(e.toString());
      GlobalToast.show('获取章节数据失败', debugMessage: e.toString());
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
    refreshEpisodeData(widget.comicId);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _currentPage <= _totalPage) {
        refreshEpisodeData(widget.comicId);
      }
    }
  }

  Widget _buildEpisodeItem(
      BuildContext context, ComicEpisodeDoc episode, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ComicReaderWidget(
              comicId: widget.comicId,
              episodeId: episode.order,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            // 章节标题
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatUpdatedTime(episode.updatedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // 右侧箭头
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: Text(
              '章节列表',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          // 章节列表
          if (_isLoading && _comicEpisodeList.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_comicEpisodeList.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('暂无章节数据'),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index == _comicEpisodeList.length) {
                    return _isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const SizedBox.shrink();
                  }
                  return _buildEpisodeItem(
                      context, _comicEpisodeList[index], index);
                },
                itemCount: _comicEpisodeList.length + 1,
              ),
            ),
        ],
      ),
    );
  }
}
