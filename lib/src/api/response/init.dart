import 'package:json_annotation/json_annotation.dart';

part 'init.g.dart';

//{"status":"ok","addresses":["104.20.180.50","104.20.181.50"],"waka":"https://ad-channel.diwodiwo.xyz","adKeyword":"diwodiwo"}
@JsonSerializable()
class ServerInitResponseData {
  final String status;
  final List<String>? addresses;
  final String? waka;
  final String? adKeyword;

  ServerInitResponseData(
      {required this.status, this.addresses, this.waka, this.adKeyword});

  factory ServerInitResponseData.fromJson(Map<String, dynamic> json) =>
      _$ServerInitResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ServerInitResponseDataToJson(this);
}
