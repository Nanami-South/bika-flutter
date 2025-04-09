// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComicDoc _$ComicDocFromJson(Map<String, dynamic> json) => ComicDoc(
      id: json['_id'] as String,
      title: json['title'] as String,
      author: json['author'] as String?,
      totalViews: (json['totalViews'] as num?)?.toInt(),
      totalLikes: (json['totalLikes'] as num?)?.toInt(),
      pagesCount: (json['pagesCount'] as num).toInt(),
      epsCount: (json['epsCount'] as num).toInt(),
      finished: json['finished'] as bool,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      thumb: Thumb.fromJson(json['thumb'] as Map<String, dynamic>),
      likesCount: (json['likesCount'] as num?)?.toInt(),
      viewsCount: (json['viewsCount'] as num?)?.toInt(),
      leaderboardCount: (json['leaderboardCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ComicDocToJson(ComicDoc instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'totalViews': instance.totalViews,
      'totalLikes': instance.totalLikes,
      'pagesCount': instance.pagesCount,
      'epsCount': instance.epsCount,
      'finished': instance.finished,
      'categories': instance.categories,
      'thumb': instance.thumb,
      'likesCount': instance.likesCount,
      'viewsCount': instance.viewsCount,
      'leaderboardCount': instance.leaderboardCount,
    };

PagedComics _$PagedComicsFromJson(Map<String, dynamic> json) => PagedComics(
      pages: (json['pages'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      docs: (json['docs'] as List<dynamic>)
          .map((e) => ComicDoc.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$PagedComicsToJson(PagedComics instance) =>
    <String, dynamic>{
      'pages': instance.pages,
      'total': instance.total,
      'docs': instance.docs,
      'page': instance.page,
      'limit': instance.limit,
    };

PagedComicsListResponseData _$PagedComicsListResponseDataFromJson(
        Map<String, dynamic> json) =>
    PagedComicsListResponseData(
      comics: PagedComics.fromJson(json['comics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PagedComicsListResponseDataToJson(
        PagedComicsListResponseData instance) =>
    <String, dynamic>{
      'comics': instance.comics,
    };

ComicsListResponseData _$ComicsListResponseDataFromJson(
        Map<String, dynamic> json) =>
    ComicsListResponseData(
      comics: (json['comics'] as List<dynamic>)
          .map((e) => ComicDoc.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ComicsListResponseDataToJson(
        ComicsListResponseData instance) =>
    <String, dynamic>{
      'comics': instance.comics,
    };

Creator _$CreatorFromJson(Map<String, dynamic> json) => Creator(
      id: json['_id'] as String,
      gender: json['gender'] as String?,
      name: json['name'] as String,
      verified: json['verified'] as bool,
      exp: (json['exp'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      role: json['role'] as String?,
      avatar: json['avatar'] == null
          ? null
          : Thumb.fromJson(json['avatar'] as Map<String, dynamic>),
      characters: (json['characters'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      title: json['title'] as String?,
      slogan: json['slogan'] as String?,
    );

Map<String, dynamic> _$CreatorToJson(Creator instance) => <String, dynamic>{
      '_id': instance.id,
      'gender': instance.gender,
      'name': instance.name,
      'verified': instance.verified,
      'exp': instance.exp,
      'level': instance.level,
      'role': instance.role,
      'avatar': instance.avatar,
      'characters': instance.characters,
      'title': instance.title,
      'slogan': instance.slogan,
    };

ComicInfo _$ComicInfoFromJson(Map<String, dynamic> json) => ComicInfo(
      id: json['_id'] as String,
      creator: Creator.fromJson(json['_creator'] as Map<String, dynamic>),
      title: json['title'] as String,
      description: json['description'] as String?,
      thumb: json['thumb'] == null
          ? null
          : Thumb.fromJson(json['thumb'] as Map<String, dynamic>),
      author: json['author'] as String?,
      chineseTeam: json['chineseTeam'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      pagesCount: (json['pagesCount'] as num).toInt(),
      epsCount: (json['epsCount'] as num).toInt(),
      finished: json['finished'] as bool,
      updatedAt: json['updated_at'] as String?,
      createdAt: json['created_at'] as String?,
      allowDownload: json['allowDownload'] as bool?,
      allowComment: json['allowComment'] as bool?,
      totalLikes: (json['totalLikes'] as num?)?.toInt(),
      totalViews: (json['totalViews'] as num?)?.toInt(),
      totalComments: (json['totalComments'] as num?)?.toInt(),
      viewsCount: (json['viewsCount'] as num?)?.toInt(),
      likesCount: (json['likesCount'] as num?)?.toInt(),
      commentsCount: (json['commentsCount'] as num?)?.toInt(),
      isFavorite: json['isFavourite'] as bool?,
      isLiked: json['isLiked'] as bool?,
    );

Map<String, dynamic> _$ComicInfoToJson(ComicInfo instance) => <String, dynamic>{
      '_id': instance.id,
      '_creator': instance.creator,
      'title': instance.title,
      'description': instance.description,
      'thumb': instance.thumb,
      'author': instance.author,
      'chineseTeam': instance.chineseTeam,
      'categories': instance.categories,
      'tags': instance.tags,
      'pagesCount': instance.pagesCount,
      'epsCount': instance.epsCount,
      'finished': instance.finished,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
      'allowDownload': instance.allowDownload,
      'allowComment': instance.allowComment,
      'totalLikes': instance.totalLikes,
      'totalViews': instance.totalViews,
      'totalComments': instance.totalComments,
      'viewsCount': instance.viewsCount,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'isFavourite': instance.isFavorite,
      'isLiked': instance.isLiked,
    };

ComicInfoResponseData _$ComicInfoResponseDataFromJson(
        Map<String, dynamic> json) =>
    ComicInfoResponseData(
      comic: ComicInfo.fromJson(json['comic'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ComicInfoResponseDataToJson(
        ComicInfoResponseData instance) =>
    <String, dynamic>{
      'comic': instance.comic,
    };

ComicEpisodeDoc _$ComicEpisodeDocFromJson(Map<String, dynamic> json) =>
    ComicEpisodeDoc(
      id: json['_id'] as String,
      order: (json['order'] as num).toInt(),
      title: json['title'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ComicEpisodeDocToJson(ComicEpisodeDoc instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'order': instance.order,
      'title': instance.title,
      'updated_at': instance.updatedAt,
    };

ComicEpisode _$ComicEpisodeFromJson(Map<String, dynamic> json) => ComicEpisode(
      docs: (json['docs'] as List<dynamic>)
          .map((e) => ComicEpisodeDoc.fromJson(e as Map<String, dynamic>))
          .toList(),
      limit: (json['limit'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pages: (json['pages'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$ComicEpisodeToJson(ComicEpisode instance) =>
    <String, dynamic>{
      'docs': instance.docs,
      'limit': instance.limit,
      'page': instance.page,
      'pages': instance.pages,
      'total': instance.total,
    };

ComicEpisodeResponseData _$ComicEpisodeResponseDataFromJson(
        Map<String, dynamic> json) =>
    ComicEpisodeResponseData(
      eps: ComicEpisode.fromJson(json['eps'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ComicEpisodeResponseDataToJson(
        ComicEpisodeResponseData instance) =>
    <String, dynamic>{
      'eps': instance.eps,
    };

ComicPicturePageDoc _$ComicPicturePageDocFromJson(Map<String, dynamic> json) =>
    ComicPicturePageDoc(
      id: json['_id'] as String,
      media: Thumb.fromJson(json['media'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ComicPicturePageDocToJson(
        ComicPicturePageDoc instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'media': instance.media,
    };

ComicPicturePages _$ComicPicturePagesFromJson(Map<String, dynamic> json) =>
    ComicPicturePages(
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      pages: (json['pages'] as num).toInt(),
      docs: (json['docs'] as List<dynamic>)
          .map((e) => ComicPicturePageDoc.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ComicPicturePagesToJson(ComicPicturePages instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'pages': instance.pages,
      'docs': instance.docs,
    };

ComicPictureEp _$ComicPictureEpFromJson(Map<String, dynamic> json) =>
    ComicPictureEp(
      id: json['_id'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$ComicPictureEpToJson(ComicPictureEp instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
    };

ComicPictureResponseData _$ComicPictureResponseDataFromJson(
        Map<String, dynamic> json) =>
    ComicPictureResponseData(
      pages: ComicPicturePages.fromJson(json['pages'] as Map<String, dynamic>),
      ep: ComicPictureEp.fromJson(json['ep'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ComicPictureResponseDataToJson(
        ComicPictureResponseData instance) =>
    <String, dynamic>{
      'pages': instance.pages,
      'ep': instance.ep,
    };
