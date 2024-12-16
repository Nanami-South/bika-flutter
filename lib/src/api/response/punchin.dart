import 'package:json_annotation/json_annotation.dart';

part 'punchin.g.dart';

@JsonSerializable()
class Res {
  final String punchInLastDay;
  final String status;

  Res({required this.punchInLastDay, required this.status});

  factory Res.fromJson(Map<String, dynamic> json) => _$ResFromJson(json);

  Map<String, dynamic> toJson() => _$ResToJson(this);
}

@JsonSerializable()
class PunchInData {
  final Res res;

  PunchInData({required this.res});

  factory PunchInData.fromJson(Map<String, dynamic> json) =>
      _$PunchInDataFromJson(json);

  Map<String, dynamic> toJson() => _$PunchInDataToJson(this);
}
