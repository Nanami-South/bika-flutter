import 'package:json_annotation/json_annotation.dart';
import 'base.dart';
part 'profile.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "_id")
  final String id;
  final String? birthday;
  final String? email;
  final String? gender;
  final String name;
  @JsonKey(name: "activation_date")
  final String? activationDate;
  final String? title;
  final String? slogan;
  final bool? verified;
  final int exp;
  final int level;
  final List<dynamic>? characters;
  @JsonKey(name: "created_at")
  final String createdAt;
  final Thumb? avatar;

  final bool isPunched;
  final String? character;

  User(
    this.id,
    this.birthday,
    this.email,
    this.gender,
    this.name,
    this.activationDate,
    this.title,
    this.slogan,
    this.verified,
    this.exp,
    this.level,
    this.characters,
    this.createdAt,
    this.avatar,
    this.isPunched,
    this.character,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class ProfileData {
  final User user;

  ProfileData({required this.user});

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}
