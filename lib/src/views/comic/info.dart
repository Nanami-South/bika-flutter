import 'package:bika/src/views/comic/episode.dart';
import 'package:bika/src/views/comic/list/paged.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/api/response/comics.dart';
import 'package:bika/src/api/comics.dart';
import 'package:bika/src/base/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bika/src/base/time.dart';

class ComicInfoPageWidget extends StatefulWidget {
  final String comicId;
  const ComicInfoPageWidget({super.key, required this.comicId});

  @override
  State<ComicInfoPageWidget> createState() => _ComicInfoPageWidgetState();
}

class _ComicInfoPageWidgetState extends State<ComicInfoPageWidget> {
  ComicInfo? _comicInfo;
  bool _isLoading = false;
  bool _isDescriptionExpanded = false;
  bool _isDoingFavorite = false;
  bool _isDoingLike = false;

  void refreshComicInfo(String comicId) async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final c = await ComicsApi.comicInfo(comicId);
      if (c != null) {
        if (mounted) {
          setState(() {
            _comicInfo = c.comic;
          });
        }
      } else {
        BikaLogger().e('fetch comic info is null, id=$comicId');
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

  Future<void> _toggleFavorite() async {
    if (_isDoingFavorite || _comicInfo == null) return;

    // 乐观更新UI状态
    setState(() {
      _isDoingFavorite = true;
      _comicInfo!.isFavorite = !(_comicInfo!.isFavorite ?? false);
    });

    try {
      await ComicsApi.favoriteComic(widget.comicId);
    } catch (e) {
      // 如果API调用失败，请求刷新漫画信息
      if (mounted) {
        refreshComicInfo(widget.comicId);
      }
      BikaLogger().e(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isDoingFavorite = false;
        });
      }
    }
  }

  Future<void> _toggleLike() async {
    if (_isDoingLike || _comicInfo == null) return;

    // 乐观更新UI状态
    setState(() {
      _isDoingLike = true;
      if (_comicInfo!.isLiked == true) {
        _comicInfo!.likesCount = _comicInfo!.likesCount! - 1;
      } else {
        _comicInfo!.likesCount = _comicInfo!.likesCount! + 1;
      }
      _comicInfo!.isLiked = !(_comicInfo!.isLiked ?? false);
    });

    try {
      await ComicsApi.likeComic(widget.comicId);
    } catch (e) {
      // 如果API调用失败，请求刷新漫画信息
      if (mounted) {
        refreshComicInfo(widget.comicId);
      }
      BikaLogger().e(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isDoingLike = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    refreshComicInfo(widget.comicId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildCreatorCell(
      BuildContext context, Creator? c, String? updatedAt) {
    if (c == null) {
      return const Text("没有作者信息");
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => CreatorComicListPageWidget(creator: c),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 作者头像
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: c.avatar?.imageUrl() ?? "",
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey[200],
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey[200],
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 作者信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            c.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (c.title != null) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                c.title!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (c.slogan != null && c.slogan!.isNotEmpty)
                      Text(
                        c.slogan!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              // 更新时间
              const SizedBox(width: 16),
              if (updatedAt != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '上次更新',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatUpdatedTime(updatedAt),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Cover + Title + Author + Index
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: _comicInfo?.thumb?.imageUrl() ?? "",
                  width: 120,
                  height: 160,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[100],
                    width: 120,
                    height: 160,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[100],
                    width: 120,
                    height: 160,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _comicInfo?.title ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_comicInfo?.author != null &&
                        _comicInfo?.author != "") ...[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => AuthorComicListPageWidget(
                                  author: _comicInfo?.author ?? ""),
                            ),
                          );
                        },
                        child: Text(
                          "作者：${_comicInfo?.author ?? "无"}",
                          style: const TextStyle(
                            color: Colors.pink,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (_comicInfo?.chineseTeam != null &&
                        _comicInfo?.chineseTeam != "") ...[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  ChineseTeamComicListPageWidget(
                                      chineseTeam:
                                          _comicInfo?.chineseTeam ?? ""),
                            ),
                          );
                        },
                        child: Text(
                          "汉化：${_comicInfo?.chineseTeam ?? "无"}",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '指数：${_comicInfo?.viewsCount}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 2. Likes, comments
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: _toggleFavorite,
                  child: Column(
                    children: [
                      Icon(
                        _comicInfo?.isFavorite == true
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: _comicInfo?.isFavorite == true
                            ? Colors.blue
                            : Colors.grey[700],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _comicInfo?.isFavorite == true ? '已收藏' : '收藏',
                        style: TextStyle(
                          color: _comicInfo?.isFavorite == true
                              ? Colors.blue
                              : Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey[200],
                ),
                GestureDetector(
                  onTap: _toggleLike,
                  child: Column(
                    children: [
                      Icon(
                        _comicInfo?.isLiked == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _comicInfo?.isLiked == true
                            ? Colors.red
                            : Colors.grey[700],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_comicInfo?.likesCount} 喜欢',
                        style: TextStyle(
                          color: _comicInfo?.isLiked == true
                              ? Colors.red
                              : Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey[200],
                ),
                Column(
                  children: [
                    Icon(Icons.comment, color: Colors.grey[700]),
                    const SizedBox(height: 4),
                    Text(
                      '${_comicInfo?.commentsCount} 评论',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 3. 上传者信息
          _buildCreatorCell(
              context, _comicInfo?.creator, _comicInfo?.updatedAt),

          const SizedBox(height: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final textSpan = TextSpan(
                    text: _comicInfo?.description ?? "",
                    style: const TextStyle(
                        height: 1.5), // TODO: 处理文字的颜色，调整主题配色的时候一起修改
                  );
                  final textPainter = TextPainter(
                    text: textSpan,
                    maxLines: 10,
                    textDirection: TextDirection.ltr,
                  )..layout(maxWidth: constraints.maxWidth);

                  final bool exceedsMaxLines = textPainter.didExceedMaxLines;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _comicInfo?.description ?? "",
                        maxLines: _isDescriptionExpanded ? null : 10,
                        overflow: _isDescriptionExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: const TextStyle(height: 1.5),
                      ),
                      if (exceedsMaxLines) ...[
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isDescriptionExpanded = !_isDescriptionExpanded;
                            });
                          },
                          child: Text(
                            _isDescriptionExpanded ? '收起' : '展开',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 4. 分类标签
          const Text('分类', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _comicInfo?.categories
                    ?.map((item) => InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      CategoryComicListPageWidget(
                                          category: item)),
                            );
                          },
                          child: Chip(
                            label: Text(item),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ))
                    .toList() ??
                [],
          ),
          const SizedBox(height: 12),
          const Text('标签', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _comicInfo?.tags
                    ?.map((item) => InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      TagComicListPageWidget(tag: item)),
                            );
                          },
                          child: Chip(
                            label: Text(item),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ))
                    .toList() ??
                [],
          ),

          const SizedBox(height: 20),

          // 5. 章节列表
          ComicEpisodeListWidget(comicId: widget.comicId),
        ],
      ),
    );
  }
}
