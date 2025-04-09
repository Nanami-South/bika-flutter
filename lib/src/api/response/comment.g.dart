// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentUser _$CommentUserFromJson(Map<String, dynamic> json) => CommentUser(
      id: json['_id'] as String,
      avatar: json['avatar'] == null
          ? null
          : Thumb.fromJson(json['avatar'] as Map<String, dynamic>),
      character: json['character'] as String?,
      characters: (json['characters'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      exp: (json['exp'] as num).toInt(),
      gender: json['gender'] as String?,
      level: (json['level'] as num).toInt(),
      name: json['name'] as String,
      role: json['role'] as String,
      slogan: json['slogan'] as String?,
      title: json['title'] as String?,
      verified: json['verified'] as bool?,
    );

Map<String, dynamic> _$CommentUserToJson(CommentUser instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'avatar': instance.avatar,
      'character': instance.character,
      'characters': instance.characters,
      'exp': instance.exp,
      'gender': instance.gender,
      'level': instance.level,
      'name': instance.name,
      'role': instance.role,
      'slogan': instance.slogan,
      'title': instance.title,
      'verified': instance.verified,
    };

CommentDoc _$CommentDocFromJson(Map<String, dynamic> json) => CommentDoc(
      id: json['_id'] as String,
      user: CommentUser.fromJson(json['_user'] as Map<String, dynamic>),
      parent: json['_parent'] as String?,
      comicId: json['_comic'] as String?,
      commentsCount: (json['commentsCount'] as num?)?.toInt(),
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
      hide: json['hide'] as bool,
      isLiked: json['isLiked'] as bool,
      isTop: json['isTop'] as bool,
      likesCount: (json['likesCount'] as num).toInt(),
      totalComments: (json['totalComments'] as num?)?.toInt(),
      isMainComment: json['isMainComment'] as bool?,
    );

Map<String, dynamic> _$CommentDocToJson(CommentDoc instance) =>
    <String, dynamic>{
      '_id': instance.id,
      '_user': instance.user,
      '_parent': instance.parent,
      '_comic': instance.comicId,
      'commentsCount': instance.commentsCount,
      'content': instance.content,
      'created_at': instance.createdAt,
      'hide': instance.hide,
      'isLiked': instance.isLiked,
      'isTop': instance.isTop,
      'likesCount': instance.likesCount,
      'totalComments': instance.totalComments,
      'isMainComment': instance.isMainComment,
    };

Comments _$CommentsFromJson(Map<String, dynamic> json) => Comments(
      docs: (json['docs'] as List<dynamic>)
          .map((e) => CommentDoc.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: Comments._parsePage(json['page']),
      limit: (json['limit'] as num).toInt(),
      pages: (json['pages'] as num).toInt(),
    );

Map<String, dynamic> _$CommentsToJson(Comments instance) => <String, dynamic>{
      'docs': instance.docs,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'pages': instance.pages,
    };

CommentListResponseData _$CommentListResponseDataFromJson(
        Map<String, dynamic> json) =>
    CommentListResponseData(
      comments: Comments.fromJson(json['comments'] as Map<String, dynamic>),
      topComments: (json['topComments'] as List<dynamic>?)
          ?.map((e) => CommentDoc.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentListResponseDataToJson(
        CommentListResponseData instance) =>
    <String, dynamic>{
      'comments': instance.comments,
      'topComments': instance.topComments,
    };
