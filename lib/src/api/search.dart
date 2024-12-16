import 'package:bika/src/api/client.dart';
import 'package:bika/src/api/response/category.dart';

class SearchPageApi {
  // 分类, tab页面上的大类
  static Future<CategoryResponseData?> categories() async {
    final response = await HttpClient.get<CategoryResponseData>(
        route: "categories",
        fromJsonT: CategoryResponseData.fromJson,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }
}
