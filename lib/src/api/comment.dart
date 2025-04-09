import 'package:bika/src/api/response/action.dart';
import 'package:bika/src/api/response/base.dart';

import 'client.dart';
import 'response/comment.dart';

class CommentApi {
  /// 获取漫画评论列表
  static Future<CommentListResponseData?> getCommentList(
      String comicId, String page) async {
    final queryParams = {
      "page": page,
    };
    final response = await HttpClient.get<CommentListResponseData>(
        route: "comics/$comicId/comments",
        fromJsonT: CommentListResponseData.fromJson,
        queryParams: queryParams,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  /// 子评论列表
  static Future<CommentListResponseData?> getReplyCommentList(
      String commentId, String page) async {
    final queryParams = {
      "page": page,
    };
    final response = await HttpClient.get<CommentListResponseData>(
        route: "comments/$commentId/childrens",
        fromJsonT: CommentListResponseData.fromJson,
        queryParams: queryParams,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  /// 点赞/取消点赞 评论
  static Future<ActionResponseData?> likeComment(String commentId) async {
    final response = await HttpClient.post<ActionResponseData>(
        route: "comments/$commentId/like",
        fromJsonT: ActionResponseData.fromJson,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  /// 发表漫画评论, 这里没有返回的 data
  static Future<EmptyData?> createComment(
      String comicId, String content) async {
    final response = await HttpClient.post<EmptyData>(
        route: "comics/$comicId/comments",
        body: {
          "content": content,
        },
        fromJsonT: EmptyData.fromJson,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  /// 发表子评论
  static Future<EmptyData?> createReplyComment(
      String commentId, String content) async {
    final response = await HttpClient.post<EmptyData>(
        route: "comments/$commentId",
        body: {"content": content},
        fromJsonT: EmptyData.fromJson,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }
}
