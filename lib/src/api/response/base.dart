import 'package:json_annotation/json_annotation.dart';

part 'base.g.dart';

class EmptyData {
  const EmptyData();

  factory EmptyData.fromJson(Map<String, dynamic> json) => const EmptyData();

  Map<String, dynamic> toJson() => {};
}

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  @JsonKey(name: 'code')
  final int code;

  @JsonKey(name: 'error')
  final String? error;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final T? data;

  ApiResponse(this.code, this.error, this.message, this.data);

  bool isTokenExpired() {
    return code == 401 && error == ErrorCode.tokenExpired.value;
  }

  // A necessary factory constructor for creating a new instance
  factory ApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ApiResponseFromJson(json, fromJsonT);

  // Method to convert this object into a map
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

typedef ApiResponseEmptyData = ApiResponse<EmptyData>;

enum ErrorCode {
  invalidBase64Image("1002"),
  wrongAccountOrPassword("1004"),
  tokenExpired("1005"),
  notFound("1007"),
  emailAlreadyExist("1008"),
  nameAlreadyExist("1009"),
  comicReviewing("1014"),
  cannotComment("1019"),
  higherLevelIsRequired("1031");

  final String value;
  const ErrorCode(this.value);

  String display() {
    switch (this) {
      case ErrorCode.invalidBase64Image:
        return '无效的base64图像';
      case ErrorCode.wrongAccountOrPassword:
        return '账号或密码错误';
      case ErrorCode.tokenExpired:
        return '登陆状态过期';
      case ErrorCode.notFound:
        return '找不到数据';
      case ErrorCode.emailAlreadyExist:
        return '邮箱已存在';
      case ErrorCode.nameAlreadyExist:
        return '名称已存在';
      case ErrorCode.comicReviewing:
        return '漫画审核中';
      case ErrorCode.cannotComment:
        return '无法发表评论';
      case ErrorCode.higherLevelIsRequired:
        return '评论等级不够';
      default:
        return '未知错误: $value';
    }
  }
}
