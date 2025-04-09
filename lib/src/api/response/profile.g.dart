// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['_id'] as String,
      json['birthday'] as String?,
      json['email'] as String?,
      json['gender'] as String?,
      json['name'] as String,
      json['activation_date'] as String?,
      json['title'] as String?,
      json['slogan'] as String?,
      json['verified'] as bool?,
      (json['exp'] as num).toInt(),
      (json['level'] as num).toInt(),
      json['characters'] as List<dynamic>?,
      json['created_at'] as String,
      json['avatar'] == null
          ? null
          : Thumb.fromJson(json['avatar'] as Map<String, dynamic>),
      json['isPunched'] as bool,
      json['character'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'birthday': instance.birthday,
      'email': instance.email,
      'gender': instance.gender,
      'name': instance.name,
      'activation_date': instance.activationDate,
      'title': instance.title,
      'slogan': instance.slogan,
      'verified': instance.verified,
      'exp': instance.exp,
      'level': instance.level,
      'characters': instance.characters,
      'created_at': instance.createdAt,
      'avatar': instance.avatar,
      'isPunched': instance.isPunched,
      'character': instance.character,
    };

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'user': instance.user,
    };
