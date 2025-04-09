import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/api/response/comics.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bika/src/views/comic/info.dart';

/// 漫画预览卡片
class ComicPreviewCardWidget extends StatefulWidget {
  final ComicDoc comic;
  const ComicPreviewCardWidget({super.key, required this.comic});

  @override
  State<ComicPreviewCardWidget> createState() => _ComicPreviewCardWidgetState();
}

class _ComicPreviewCardWidgetState extends State<ComicPreviewCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ComicInfoPageWidget(comicId: widget.comic.id),
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
                imageUrl: widget.comic.thumb.imageUrl(),
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
                widget.comic.title,
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
}

class ComicPreviewCardListWidget extends StatefulWidget {
  final List<ComicDoc> comics;
  const ComicPreviewCardListWidget({super.key, required this.comics});

  @override
  State<ComicPreviewCardListWidget> createState() =>
      _ComicPreviewCardListWidgetState();
}

class _ComicPreviewCardListWidgetState
    extends State<ComicPreviewCardListWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        children: widget.comics.map((item) {
          return Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: ComicPreviewCardWidget(
              comic: item,
            ),
          );
        }).toList(),
      ),
    );
  }
}
