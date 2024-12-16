import 'package:json_annotation/json_annotation.dart';

part 'action.g.dart';

@JsonSerializable()
class ActionResponseData {
  final String action;

  ActionResponseData(this.action);

  factory ActionResponseData.fromJson(Map<String, dynamic> json) =>
      _$ActionResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ActionResponseDataToJson(this);
}
