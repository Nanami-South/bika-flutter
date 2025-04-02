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
  ComicPicturePages? _comicPicturePages;
  bool _isLoading = false;

  void refreshComicData(String comicId, int episodeId) async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final c = await ComicsApi.comicPictureData(comicId, episodeId);
      if (c != null) {
        if (mounted) {
          setState(() {
            _comicPictureEp = c.ep;
            _comicPicturePages = c.pages;
          });
        }
      } else {
        BikaLogger().e('fetch comic picture data is null, id=$comicId');
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
    refreshComicData(widget.comicId, widget.episodeId);
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_comicPictureEp == null || _comicPicturePages == null) {
      return const Center(child: Text('获取漫画章节数据失败'));
    } else {
      return ListView.builder(
        itemCount: _comicPicturePages!.docs.length,
        itemBuilder: (context, index) {
          final imageUrl = _comicPicturePages!.docs[index].media.imageUrl();
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
