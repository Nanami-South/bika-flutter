import 'package:json_annotation/json_annotation.dart';

part 'base.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  @JsonKey(name: 'code')
  final int code;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final T? data;

  ApiResponse(this.code, this.message, this.data);

  // A necessary factory constructor for creating a new instance
  factory ApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ApiResponseFromJson(json, fromJsonT);

  // Method to convert this object into a map
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

enum ResponseCode {
  invalidBase64Image(1002),
  wrongAccountOrPassword(1004),
  tokenExpired(1005),
  notFound(1007),
  emailAlreadyExist(1008),
  nameAlreadyExist(1009),
  comicReviewing(1014),
  cannotComment(1019),
  higherLevelIsRequired(1031);

  final int value;
  const ResponseCode(this.value);

  String display() {
    switch (this) {
      case ResponseCode.invalidBase64Image:
        return '无效的base64图像';
      case ResponseCode.wrongAccountOrPassword:
        return '账号或密码错误';
      case ResponseCode.tokenExpired:
        return '登陆状态过期';
      case ResponseCode.notFound:
        return '找不到数据';
      case ResponseCode.emailAlreadyExist:
        return '邮箱已存在';
      case ResponseCode.nameAlreadyExist:
        return '名称已存在';
      case ResponseCode.comicReviewing:
        return '漫画审核中';
      case ResponseCode.cannotComment:
        return '无法发表评论';
      case ResponseCode.higherLevelIsRequired:
        return '评论等级不够';
      default:
        return '未知错误: $value';
    }
  }
}
