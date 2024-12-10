import 'package:bika/src/api/client.dart';

class LoginApi {
  static Future<String> login(String username, String password) async {
    final response = await HttpClient.login(username, password);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    if (response.data?.token == null) {
      throw Exception('token is null');
    }
    return response.data?.token ?? '';
  }

  // static Future<void> nodeinfo() async {
  //   final response = await HttpClient.nodeinfo();
  //   //{"status":"ok","addresses":["104.20.180.50","104.20.181.50"],"waka":"https://ad-channel.diwodiwo.xyz","adKeyword":"diwodiwo"}
  //   print(response.data?.addresses);
  // }
}
