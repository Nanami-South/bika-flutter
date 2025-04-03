import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Thumb {
  final String fileServer;
  final String originalName;
  final String path;

  Thumb(this.fileServer, this.originalName, this.path);

  factory Thumb.fromJson(Map<String, dynamic> json) => _$ThumbFromJson(json);

  Map<String, dynamic> toJson() => _$ThumbToJson(this);

  String get url {
    return "https://s3.picacomic.com/static/$path";
  }
}

// {
//   "title": "嗶咔畫廊",
//   "thumb": {
//     "originalName": "picacomic-paint.jpg",
//     "path": "picacomic-paint.jpg",
//     "fileServer": "https://diwodiwo.xyz/static/"
//   },
//   "isWeb": true,
//   "link": "https://paint-web.bidobido.xyz",
//   "active": true
// },
// {
//   "_id": "5821859b5f6b9a4f93dbf6cd",
//   "title": "長篇",
//   "description": "未知",
//   "thumb": {
//     "originalName": "長篇.jpg",
//     "path": "681081e7-9694-436a-97e4-898fc68a8f89.jpg",
//     "fileServer": "https://storage1.picacomic.com"
//   }
// },
@JsonSerializable()
class Category {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final Thumb thumb;
  final bool? isWeb;
  final bool? active;
  final String? link;
  final String? description;

  Category(this.id, this.title, this.thumb, this.isWeb, this.active, this.link,
      this.description);

  String get coverUrl {
    return thumb.url;
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class CategoryResponseData {
  List<Category> categories;

  CategoryResponseData(this.categories);

  factory CategoryResponseData.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseDataToJson(this);
}
