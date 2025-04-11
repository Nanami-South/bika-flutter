import 'package:bika/src/api/comment.dart';
import 'package:bika/src/base/logger.dart';
import 'package:bika/src/views/toast.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/api/response/comment.dart';
import 'package:timeago/timeago.dart' as timeago;

/// 评论列表卡片
class CommentListCardWidget extends StatefulWidget {
  final CommentDoc comment;
  final bool canBeReplied;
  final Function(CommentDoc)? onLikeChanged;
  final Function(CommentDoc)? onReply;
  const CommentListCardWidget({
    super.key,
    required this.comment,
    this.canBeReplied = true,
    this.onLikeChanged,
    this.onReply,
  });

  @override
  State<CommentListCardWidget> createState() => _CommentListCardWidgetState();
}

class _CommentListCardWidgetState extends State<CommentListCardWidget> {
  bool _isDoingLike = false;

  Future<void> _toggleLike() async {
    if (_isDoingLike) return;

    // 乐观更新UI状态
    setState(() {
      _isDoingLike = true;
      widget.comment.isLiked = !widget.comment.isLiked;
      widget.comment.likesCount = widget.comment.isLiked
          ? widget.comment.likesCount + 1
          : widget.comment.likesCount - 1;
    });

    try {
      await CommentApi.likeComment(widget.comment.id);
      // 通知父组件点赞状态变化
      widget.onLikeChanged?.call(widget.comment);
    } catch (e) {
      // 如果API调用失败, 撤回点赞
      if (mounted) {
        setState(() {
          widget.comment.isLiked = !widget.comment.isLiked;
          widget.comment.likesCount = widget.comment.isLiked
              ? widget.comment.likesCount + 1
              : widget.comment.likesCount - 1;
        });
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息行
          Row(
            children: [
              // 用户头像
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: widget.comment.user.avatar?.path != null
                    ? ClipOval(
                        child: Image.network(
                          widget.comment.user.avatar!.imageUrl(),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Text(widget.comment.user.name[0].toUpperCase()),
              ),
              const SizedBox(width: 8),
              // 用户名和等级
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.comment.user.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Lv.${widget.comment.user.level}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${widget.comment.user.gender == 'm' ? '(绅士)' : widget.comment.user.gender == 'f' ? '(淑女)' : '(机器人)'} ${timeago.format(DateTime.parse(widget.comment.createdAt), locale: 'zh')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // 点赞数
              GestureDetector(
                onTap: () {
                  _toggleLike();
                },
                child: Row(
                  children: [
                    Text(
                      widget.comment.likesCount.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      widget.comment.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 20,
                      color: widget.comment.isLiked
                          ? Colors.pink
                          : Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 评论内容
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 48),
            child: Row(
              children: [
                if (widget.comment.isTop)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.pink[100]!,
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      '置顶',
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (widget.canBeReplied) {
                        widget.onReply?.call(widget.comment);
                      }
                    },
                    child: Text(
                      widget.comment.content,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 回复数
          if (widget.canBeReplied &&
              widget.comment.commentsCount != null &&
              widget.comment.commentsCount! > 0)
            GestureDetector(
              onTap: () {
                // 打开回复列表浮窗
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ReplyCommentListPageWidget(
                      comment: widget.comment,
                      onLikeChanged: widget.onLikeChanged),
                );

                // 等弹窗完全关闭后再取消一次焦点，防止系统恢复上一个 focusNode
                // 延迟一帧确保系统恢复完焦点我们再清空
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                });
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8, left: 40),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '共${widget.comment.commentsCount}条回复 >',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CommentListPageWidget extends StatefulWidget {
  final String comicId;
  const CommentListPageWidget({super.key, required this.comicId});

  @override
  State<CommentListPageWidget> createState() => _CommentListPageWidgetState();
}

class _CommentListPageWidgetState extends State<CommentListPageWidget> {
  final List<CommentDoc> _commentDocList = [];
  int _currentPage = 1;
  int? _maxPages;
  bool _lastLoadingListError = false;
  bool _isLoadingList = false;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  // 添加回复相关的状态
  CommentDoc? _replyingToComment;
  String _replyHintText = "输入伟论";

  final ScrollController _scrollController = ScrollController();

  // 添加切换回复模式的方法
  void _toggleReplyMode(CommentDoc? comment) {
    setState(() {
      _replyingToComment = comment;
      _replyHintText = comment != null ? "输入回复" : "输入伟论";
      if (comment != null) {
        FocusScope.of(context).requestFocus(_commentFocusNode);
      }
    });
  }

  // 修改发送评论的方法
  void _handleSendComicComment(String content) async {
    if (content.trim().isEmpty) {
      GlobalToast.show("评论内容不能为空");
      return;
    }

    try {
      if (_replyingToComment != null) {
        // 发送回复
        await CommentApi.createReplyComment(_replyingToComment!.id, content);
        GlobalToast.show("回复发送成功");
      } else {
        // 发送评论
        await CommentApi.createComment(widget.comicId, content);
        GlobalToast.show("评论发送成功");
      }

      if (mounted) {
        setState(() {
          _commentController.clear();
          FocusScope.of(context).unfocus();
          _replyingToComment = null;
          _replyHintText = "发表伟论";
        });
        // 刷新评论列表
        _commentDocList.clear();
        _currentPage = 1;
        fetchNextPage();
      }
    } catch (e) {
      BikaLogger().e(e.toString());
      GlobalToast.show(
          _replyingToComment != null ? "回复发送失败，请稍后重试" : "评论发送失败，请稍后重试");
    }
  }

  void _handleLikeChanged(CommentDoc updatedComment) {
    setState(() {
      // 更新主评论列表中的评论状态
      final index =
          _commentDocList.indexWhere((c) => c.id == updatedComment.id);
      if (index != -1) {
        _commentDocList[index] = updatedComment;
      }
    });
  }

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
      final c = await CommentApi.getCommentList(
          widget.comicId, _currentPage.toString());
      if (c != null) {
        if (mounted) {
          setState(() {
            if (_currentPage == 1 && c.topComments != null) {
              _commentDocList.addAll(c.topComments!);
            }
            _commentDocList.addAll(c.comments.docs);

            _currentPage += 1;
            _maxPages = c.comments.pages;
            // 第一次滑到底部给出toast提示
            if (_currentPage > _maxPages!) {
              GlobalToast.show("已经滑到底部啦",
                  debugMessage: "$_currentPage/$_maxPages");
            }
          });
        }
      } else {
        BikaLogger().e('fetch comment list is null');
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
    _commentController.dispose();
    _commentFocusNode.dispose();
    _scrollController.removeListener(_onScrollChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("评论", style: TextStyle(color: Colors.black)),
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

  Widget _buildCommentList(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _commentDocList.length + 1,
        itemBuilder: (context, index) {
          if (index >= _commentDocList.length) {
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

          return CommentListCardWidget(
            comment: _commentDocList[index],
            onLikeChanged: _handleLikeChanged,
            onReply: (comment) {
              _toggleReplyMode(comment);
            },
          );
        },
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Column(
        children: [
          // 添加回复提示和取消按钮
          if (_replyingToComment != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    "回复 ${_replyingToComment!.user.name}",
                    style: TextStyle(
                      color: Colors.pink[300],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      _toggleReplyMode(null);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.pink[200]!,
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.pink,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "取消",
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _commentController,
                    focusNode: _commentFocusNode,
                    decoration: InputDecoration(
                      hintText: _replyHintText,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: InputBorder.none,
                    ),
                    maxLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      _handleSendComicComment(value);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.pink[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  onPressed: () {
                    _handleSendComicComment(_commentController.text);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _buildCommentList(context),
        ),
        _buildCommentInput(context),
      ],
    );
  }
}

/// 回复列表页面
class ReplyCommentListPageWidget extends StatefulWidget {
  final CommentDoc comment;
  final Function(CommentDoc)? onLikeChanged;
  const ReplyCommentListPageWidget({
    super.key,
    required this.comment,
    this.onLikeChanged,
  });

  @override
  State<ReplyCommentListPageWidget> createState() =>
      _ReplyCommentListPageWidgetState();
}

class _ReplyCommentListPageWidgetState
    extends State<ReplyCommentListPageWidget> {
  final List<CommentDoc> _replyCommentDocList = [];
  int _currentPage = 1;
  int? _maxPages;
  bool _lastLoadingListError = false;
  bool _isLoadingList = false;

  final ScrollController _scrollController = ScrollController();

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
      final c = await CommentApi.getReplyCommentList(
          widget.comment.id, _currentPage.toString());
      if (c != null) {
        if (mounted) {
          setState(() {
            _replyCommentDocList.addAll(c.comments.docs);

            _currentPage += 1;
            _maxPages = c.comments.pages;
          });
        }
      } else {
        BikaLogger().e('fetch reply comment list is null');
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // 顶部拖动手柄
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 添加回退箭头
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '${widget.comment.commentsCount ?? 0}条回复',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // 原始的被回复的评论
          CommentListCardWidget(
            comment: widget.comment,
            canBeReplied: false,
            onLikeChanged: widget.onLikeChanged,
          ),
          // 回复列表
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '回复列表',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                // 列表内容
                if (_isLoadingList && _replyCommentDocList.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_replyCommentDocList.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('暂无回复'),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        if (index >= _replyCommentDocList.length) {
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
                        return CommentListCardWidget(
                          comment: _replyCommentDocList[index],
                          canBeReplied: false,
                          onLikeChanged: widget.onLikeChanged,
                        );
                      },
                      itemCount: _replyCommentDocList.length + 1,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
