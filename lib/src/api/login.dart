import 'package:bika/src/api/client.dart';
import 'package:bika/src/api/response/login.dart';

class LoginApi {
  static Future<String> login(String username, String password) async {
    final response = await HttpClient.post<LoginResponseData>(
        route: "auth/sign-in",
        body: {
          "email": username,
          "password": password,
        },
        fromJsonT: LoginResponseData.fromJson);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    if (response.data?.token == null) {
      throw Exception('token is null');
    }
    return response.data?.token ?? '';
  }
}
