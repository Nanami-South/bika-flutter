import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'base.dart';
part 'comics.g.dart';

@JsonSerializable()
class ComicDoc {
  @JsonKey(name: '_id')
  final String id;

  final String title;
  final String? author;
  final int? totalViews;
  final int? totalLikes;
  final int pagesCount;
  final int epsCount;
  final bool finished;
  final List<String>? categories;
  final Thumb thumb;

  final int? likesCount;
  final int? viewsCount;
  final int? leaderboardCount;

  ComicDoc({
    required this.id,
    required this.title,
    this.author,
    this.totalViews,
    this.totalLikes,
    required this.pagesCount,
    required this.epsCount,
    required this.finished,
    this.categories,
    required this.thumb,
    this.likesCount,
    this.viewsCount,
    this.leaderboardCount,
  });

  factory ComicDoc.fromJson(Map<String, dynamic> json) =>
      _$ComicDocFromJson(json);

  Map<String, dynamic> toJson() => _$ComicDocToJson(this);
}

@JsonSerializable()
class PagedComics {
  final int pages;
  final int total;
  final List<ComicDoc> docs;
  final int page;
  final int limit;

  PagedComics(
      {required this.pages,
      required this.total,
      required this.docs,
      required this.page,
      required this.limit});

  factory PagedComics.fromJson(Map<String, dynamic> json) =>
      _$PagedComicsFromJson(json);

  Map<String, dynamic> toJson() => _$PagedComicsToJson(this);
}

// 带有翻页信息的漫画列表数据
@JsonSerializable()
class PagedComicsListResponseData {
  final PagedComics comics;
  PagedComicsListResponseData({required this.comics});
  factory PagedComicsListResponseData.fromJson(Map<String, dynamic> json) =>
      _$PagedComicsListResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$PagedComicsListResponseDataToJson(this);
}

// 漫画列表回复数据
@JsonSerializable()
class ComicsListResponseData {
  final List<ComicDoc> comics;
  ComicsListResponseData({required this.comics});
  factory ComicsListResponseData.fromJson(Map<String, dynamic> json) =>
      _$ComicsListResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ComicsListResponseDataToJson(this);
}

@JsonSerializable()
class Creator {
  @JsonKey(name: '_id')
  final String id;
  final String? gender;
  final String name;
  final bool verified;
  final int exp;
  final int level;
  final String? role;
  final Thumb? avatar;
  final List<String>? characters;
  final String? title;
  final String? slogan;

  Creator(
      {required this.id,
      this.gender,
      required this.name,
      required this.verified,
      required this.exp,
      required this.level,
      this.role,
      this.avatar,
      this.characters,
      this.title,
      this.slogan});

  factory Creator.fromJson(Map<String, dynamic> json) =>
      _$CreatorFromJson(json);

  Map<String, dynamic> toJson() => _$CreatorToJson(this);
}

@JsonSerializable()
class ComicInfo {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: '_creator')
  final Creator creator;

  final String title;
  final String? description;
  final Thumb? thumb;
  final String? author;
  final String? chineseTeam;
  final List<String>? categories;
  final List<String>? tags;
  final int pagesCount;
  final int epsCount;
  final bool finished;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  final bool? allowDownload;
  final bool? allowComment;
  final int? totalLikes;
  final int? totalViews;
  final int? totalComments;
  final int? viewsCount;
  int? likesCount;
  final int? commentsCount;

  @JsonKey(name: 'isFavourite')
  bool? isFavorite;
  bool? isLiked;
  ComicInfo(
      {required this.id,
      required this.creator,
      required this.title,
      this.description,
      this.thumb,
      this.author,
      this.chineseTeam,
      this.categories,
      this.tags,
      required this.pagesCount,
      required this.epsCount,
      required this.finished,
      this.updatedAt,
      this.createdAt,
      this.allowDownload,
      this.allowComment,
      this.totalLikes,
      this.totalViews,
      this.totalComments,
      this.viewsCount,
      this.likesCount,
      this.commentsCount,
      this.isFavorite,
      this.isLiked});

  factory ComicInfo.fromJson(Map<String, dynamic> json) =>
      _$ComicInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ComicInfoToJson(this);
}

// 漫画详情接口
@JsonSerializable()
class ComicInfoResponseData {
  final ComicInfo comic;
  ComicInfoResponseData({required this.comic});
  factory ComicInfoResponseData.fromJson(Map<String, dynamic> json) =>
      _$ComicInfoResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ComicInfoResponseDataToJson(this);
}

@JsonSerializable()
class ComicEpisodeDoc {
  @JsonKey(name: '_id')
  final String id;
  final int order;
  final String title;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  ComicEpisodeDoc({
    required this.id,
    required this.order,
    required this.title,
    required this.updatedAt,
  });

  factory ComicEpisodeDoc.fromJson(Map<String, dynamic> json) =>
      _$ComicEpisodeDocFromJson(json);

  Map<String, dynamic> toJson() => _$ComicEpisodeDocToJson(this);
}

@JsonSerializable()
class ComicEpisode {
  final List<ComicEpisodeDoc> docs;
  final int limit;
  final int page;
  final int pages;
  final int total;
  ComicEpisode({
    required this.docs,
    required this.limit,
    required this.page,
    required this.pages,
    required this.total,
  });

  factory ComicEpisode.fromJson(Map<String, dynamic> json) =>
      _$ComicEpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$ComicEpisodeToJson(this);
}

@JsonSerializable()
class ComicEpisodeResponseData {
  final ComicEpisode eps;
  ComicEpisodeResponseData({
    required this.eps,
  });

  factory ComicEpisodeResponseData.fromJson(Map<String, dynamic> json) =>
      _$ComicEpisodeResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ComicEpisodeResponseDataToJson(this);
}

@JsonSerializable()
class ComicPicturePageDoc {
  @JsonKey(name: '_id')
  final String id;
  final Thumb media;

  ComicPicturePageDoc({
    required this.id,
    required this.media,
  });

  factory ComicPicturePageDoc.fromJson(Map<String, dynamic> json) =>
      _$ComicPicturePageDocFromJson(json);

  Map<String, dynamic> toJson() => _$ComicPicturePageDocToJson(this);
}

@JsonSerializable()
class ComicPicturePages {
  final int total;
  final int page;
  final int limit;
  final int pages;
  final List<ComicPicturePageDoc> docs;

  ComicPicturePages({
    required this.total,
    required this.page,
    required this.limit,
    required this.pages,
    required this.docs,
  });

  factory ComicPicturePages.fromJson(Map<String, dynamic> json) =>
      _$ComicPicturePagesFromJson(json);

  Map<String, dynamic> toJson() => _$ComicPicturePagesToJson(this);
}

@JsonSerializable()
class ComicPictureEp {
  @JsonKey(name: "_id")
  final String id;
  final String title;

  ComicPictureEp({
    required this.id,
    required this.title,
  });

  factory ComicPictureEp.fromJson(Map<String, dynamic> json) =>
      _$ComicPictureEpFromJson(json);

  Map<String, dynamic> toJson() => _$ComicPictureEpToJson(this);
}

@JsonSerializable()
class ComicPictureResponseData {
  final ComicPicturePages pages;
  final ComicPictureEp ep;
  ComicPictureResponseData({
    required this.pages,
    required this.ep,
  });

  factory ComicPictureResponseData.fromJson(Map<String, dynamic> json) =>
      _$ComicPictureResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ComicPictureResponseDataToJson(this);
}
