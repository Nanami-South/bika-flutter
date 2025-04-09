import 'package:json_annotation/json_annotation.dart';
import 'base.dart';
part 'category.g.dart';

@JsonSerializable()
class Category {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final Thumb thumb;
  final bool? isWeb;
  final bool? active;
  final String? link;
  final String? description;

  Category(this.id, this.title, this.thumb, this.isWeb, this.active, this.link,
      this.description);

  String get coverUrl {
    return thumb.imageUrl();
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class CategoryResponseData {
  List<Category> categories;

  CategoryResponseData(this.categories);

  factory CategoryResponseData.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseDataToJson(this);
}
