// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'init.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerInitResponseData _$ServerInitResponseDataFromJson(
        Map<String, dynamic> json) =>
    ServerInitResponseData(
      status: json['status'] as String,
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      waka: json['waka'] as String?,
      adKeyword: json['adKeyword'] as String?,
    );

Map<String, dynamic> _$ServerInitResponseDataToJson(
        ServerInitResponseData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'addresses': instance.addresses,
      'waka': instance.waka,
      'adKeyword': instance.adKeyword,
    };
