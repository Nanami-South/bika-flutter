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
  ComicEpisode? _comicEpisode;
  bool _isLoading = false;
  bool _isExpanded = false;

  void refreshEpisodeData(String comicId) async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final c = await ComicsApi.comicEpisodeData(comicId);
      if (c != null) {
        if (mounted) {
          setState(() {
            _comicEpisode = c.eps;
          });
        }
      } else {
        BikaLogger().e('fetch comic episode data is null, id=$comicId');
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
    refreshEpisodeData(widget.comicId);
  }

  Widget _buildEpisodeItem(
      BuildContext context, ComicEpisodeDoc episode, int index) {
    return GestureDetector(
      onTap: () {
        // TODO: 跳转到漫画章节详情页
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            // 章节序号
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${_comicEpisode!.docs.length - index}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            '章节列表',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // 章节列表
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_comicEpisode == null)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('暂无章节数据'),
            ),
          )
        else
          Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildEpisodeItem(
                      context, _comicEpisode!.docs[index], index);
                },
                itemCount: _isExpanded
                    ? _comicEpisode?.docs.length ?? 0
                    : (_comicEpisode!.docs.length > 8
                        ? 8
                        : _comicEpisode!.docs.length),
              ),
              if ((_comicEpisode?.docs.length ?? 0) > 8)
                InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isExpanded ? '收起' : '展开更多',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 14,
                          ),
                        ),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.blue[700],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
