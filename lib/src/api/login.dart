import 'package:bika/src/api/response/base.dart';

import 'client.dart';
import 'response/login.dart';

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

  static Future<EmptyData?> register(
    String nickname,
    String username,
    String password,
    String birthday,
    String gender,
    String securityQuestion1,
    String securityAnswer1,
    String securityQuestion2,
    String securityAnswer2,
    String securityQuestion3,
    String securityAnswer3,
  ) async {
    final body = {
      "question1": securityQuestion1,
      "answer1": securityAnswer1,
      "question2": securityQuestion2,
      "answer2": securityAnswer2,
      "question3": securityQuestion3,
      "answer3": securityAnswer3,
      "birthday": birthday,
      "email": username,
      "gender": gender,
      "name": nickname,
      "password": password,
    };
    final response = await HttpClient.post<EmptyData>(
        route: "auth/register", body: body, fromJsonT: EmptyData.fromJson);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }
}
