// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'punchin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Res _$ResFromJson(Map<String, dynamic> json) => Res(
      punchInLastDay: json['punchInLastDay'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$ResToJson(Res instance) => <String, dynamic>{
      'punchInLastDay': instance.punchInLastDay,
      'status': instance.status,
    };

PunchInData _$PunchInDataFromJson(Map<String, dynamic> json) => PunchInData(
      res: Res.fromJson(json['res'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PunchInDataToJson(PunchInData instance) =>
    <String, dynamic>{
      'res': instance.res,
    };
