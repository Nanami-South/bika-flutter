import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/api/response/comics.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bika/src/views/comic/info.dart';

/// 漫画列表卡片
class ComicListCardWidget extends StatefulWidget {
  final ComicDoc comic;
  const ComicListCardWidget({super.key, required this.comic});

  @override
  State<ComicListCardWidget> createState() => _ComicListCardWidgetState();
}

class _ComicListCardWidgetState extends State<ComicListCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ComicInfoPageWidget(comicId: widget.comic.id),
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
                imageUrl: widget.comic.thumb.imageUrl(),
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
                            widget.comic.title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${widget.comic.pagesCount}P",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black),
                          ),
                          Text(
                            widget.comic.author ?? "",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.pink),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "分类: ${widget.comic.categories?.join(", ") ?? ""}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black87),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Row(
                          children: [
                            const Icon(Icons.favorite,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text("${widget.comic.totalLikes}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            const SizedBox(width: 12),
                            const Icon(Icons.visibility,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text("${widget.comic.totalViews}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
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
}
