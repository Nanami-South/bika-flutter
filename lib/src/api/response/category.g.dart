// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      json['_id'] as String?,
      json['title'] as String,
      Thumb.fromJson(json['thumb'] as Map<String, dynamic>),
      json['isWeb'] as bool?,
      json['active'] as bool?,
      json['link'] as String?,
      json['description'] as String?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'thumb': instance.thumb,
      'isWeb': instance.isWeb,
      'active': instance.active,
      'link': instance.link,
      'description': instance.description,
    };

CategoryResponseData _$CategoryResponseDataFromJson(
        Map<String, dynamic> json) =>
    CategoryResponseData(
      (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryResponseDataToJson(
        CategoryResponseData instance) =>
    <String, dynamic>{
      'categories': instance.categories,
    };
