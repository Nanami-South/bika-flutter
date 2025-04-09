import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'base.dart';
part 'comment.g.dart';

@JsonSerializable()
class CommentUser {
  @JsonKey(name: '_id')
  final String id;
  final Thumb? avatar;
  final String? character;
  final List<String>? characters;
  final int exp;
  final String? gender;
  final int level;
  final String name;
  final String role;
  final String? slogan;
  final String? title;
  final bool? verified;

  CommentUser(
      {required this.id,
      this.avatar,
      this.character,
      this.characters,
      required this.exp,
      this.gender,
      required this.level,
      required this.name,
      required this.role,
      this.slogan,
      this.title,
      this.verified});

  factory CommentUser.fromJson(Map<String, dynamic> json) =>
      _$CommentUserFromJson(json);

  Map<String, dynamic> toJson() => _$CommentUserToJson(this);
}

@JsonSerializable()
class CommentDoc {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: '_user')
  final CommentUser user;
  @JsonKey(name: '_parent')
  final String? parent;
  @JsonKey(name: '_comic')
  final String? comicId;

  final int? commentsCount;
  final String content;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final bool hide;
  bool isLiked;
  final bool isTop;
  int likesCount;
  final int? totalComments;
  final bool? isMainComment;

  CommentDoc(
      {required this.id,
      required this.user,
      this.parent,
      this.comicId,
      this.commentsCount,
      required this.content,
      required this.createdAt,
      required this.hide,
      required this.isLiked,
      required this.isTop,
      required this.likesCount,
      this.totalComments,
      this.isMainComment});

  factory CommentDoc.fromJson(Map<String, dynamic> json) =>
      _$CommentDocFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDocToJson(this);
}

@JsonSerializable()
class Comments {
  final List<CommentDoc> docs;
  final int total;
  @JsonKey(fromJson: _parsePage)
  final int page;
  final int limit;
  final int pages;

  Comments(
      {required this.docs,
      required this.total,
      required this.page,
      required this.limit,
      required this.pages});

  factory Comments.fromJson(Map<String, dynamic> json) =>
      _$CommentsFromJson(json);

  Map<String, dynamic> toJson() => _$CommentsToJson(this);

  /// 不知道为啥bika的服务器在这里返回String类型，和别的不一样，这里做个判断一了百了
  static int _parsePage(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? -1;
    return -1;
  }
}

@JsonSerializable()
class CommentListResponseData {
  final Comments comments;
  final List<CommentDoc>? topComments;

  CommentListResponseData({required this.comments, this.topComments});

  factory CommentListResponseData.fromJson(Map<String, dynamic> json) =>
      _$CommentListResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$CommentListResponseDataToJson(this);
}
