import 'dart:convert';
import 'package:bika/src/api/response/base.dart';
import 'package:bika/src/api/response/init.dart';
import 'package:bika/src/api/response/login.dart';
import 'package:http/http.dart' as http;
import 'signature.dart';

enum RequestMethod {
  get("GET"),
  post("POST");

  final String value;

  const RequestMethod(this.value);

  @override
  String toString() => value;
}

enum RequestRoute {
  serverInit("init"),
  login("auth/sign-in");

  final String value;

  const RequestRoute(this.value);

  @override
  String toString() => value;
}

class HeaderBuilder {
  static const _apiKey = "C69BAF41DA5ABD1FFEDC6D2FEA56B";
  static Future<Map<String, String>> _completeHeaders(
      RequestRoute route,
      RequestMethod method,
      String? token,
      Map<String, String>? extraHeaders) async {
    int timestampInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final timestamp = timestampInSeconds.toString();
    final nonce = await SignatureTool.generateNonce();
    final methodStr = method.value;
    final toSign = route.value + timestamp + nonce + methodStr + _apiKey;
    final signature = await SignatureTool.sign(toSign);
    var headers = {
      "api-key": _apiKey,
      "accept": "application/vnd.picacomic.com.v1+json",
      "app-channel": "2", // 分流节点，1表示分流1，2表示分流2
      "time": timestamp,
      "nonce": nonce,
      "signature": signature ?? "",
      "app-version": "2.2.1.3.3.4",
      "app-uuid": "defaultUuid",
      "image-quality": "original",
      "app-platform": "android",
      "app-build-version": "45",
      "user-agent": "okhttp/3.8.1",
    };
    if (extraHeaders != null) {
      extraHeaders.forEach((key, value) {
        headers[key] = value;
      });
    }
    if (token != null && token.isNotEmpty) {
      headers["authorization"] = token;
    }
    return headers;
  }

  static Future<Map<String, String>> completeAppHeaders(
      RequestRoute route,
      RequestMethod method,
      String? token,
      Map<String, String>? extraHeaders) async {
    return _completeHeaders(route, method, token, extraHeaders);
  }
}

class HttpClient {
  // static const _serverHost = "https://picaapi.picacomic.com/";
  static const _serverHost = "http://104.20.180.50/";
  static const _initHost = "http://68.183.234.72/";

  static final _client = http.Client();

  static Future<ApiResponse<LoginResponseData>> login(
      String username, String password) async {
    const route = RequestRoute.login;
    final headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Host": "picaapi.picacomic.com",
    };
    final completeHeaders = await HeaderBuilder.completeAppHeaders(
        RequestRoute.login, RequestMethod.post, null, headers);

    final url = Uri.parse("$_serverHost${route.value}");
    final body = jsonEncode({
      "email": username,
      "password": password,
    });
    final response =
        await _client.post(url, headers: completeHeaders, body: body);
    return ApiResponse<LoginResponseData>.fromJson(jsonDecode(response.body),
        (json) => LoginResponseData.fromJson(json as Map<String, dynamic>));
  }

  static Future<ApiResponse<ServerInitResponseData>> init() async {
    const route = RequestRoute.serverInit;
    final headers = await HeaderBuilder.completeAppHeaders(
        RequestRoute.serverInit, RequestMethod.get, null, null);
    final url = Uri.parse("$_initHost$route");
    final response = await _client.get(url, headers: headers);
    return ApiResponse<ServerInitResponseData>.fromJson(
        jsonDecode(response.body),
        (json) =>
            ServerInitResponseData.fromJson(json as Map<String, dynamic>));
  }
}
