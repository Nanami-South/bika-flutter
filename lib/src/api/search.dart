import 'package:bika/src/api/client.dart';
import 'package:bika/src/api/response/category.dart';

class SearchPageApi {
  static Future<CategoryResponseData?> categories() async {
    final response = await HttpClient.categories();
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }
}
