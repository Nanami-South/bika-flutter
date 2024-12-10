import 'dart:convert';
import 'package:bika/src/api/response/base.dart';
import 'package:bika/src/api/response/category.dart';
import 'package:bika/src/api/response/init.dart';
import 'package:bika/src/api/response/login.dart';
import 'package:bika/src/model/account.dart';
import 'package:bika/src/svc/logger.dart';
import 'package:http/http.dart' as http;
import 'signature.dart';

enum RequestMethod {
  get("GET"),
  post("POST"),
  put("PUT");

  final String value;

  const RequestMethod(this.value);

  @override
  String toString() => value;
}

enum RequestRoute {
  serverInit("init"),
  register("auth/register"),
  login("auth/sign-in"),
  forgotPassword("auth/forgot-password"),
  resetPassword("auth/reset-password"),
  changePassword("users/password"),
  collections("collections"),
  categories("categories"),
  knightBoard("comics/knight-leaderboard"),
  leaderboard("comics/leaderboard"),
  comics("comics"),
  searchComics("comics/search"),
  hotKeywords("keywords"),
  randomComics("comics/random"),
  selfProfile("users/profile");

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

  static Future<void> register() async {
    const route = RequestRoute.register;
    final headers = await HeaderBuilder.completeAppHeaders(
        RequestRoute.register, RequestMethod.post, null, null);
    final url = Uri.parse("$_serverHost$route");
    final body = jsonEncode({
      "todo": "todo",
    });
    final response = await _client.post(url, headers: headers, body: body);
    print(response.statusCode);
    print(response.body);
  }

  static Future<void> forgotPassword() async {
    const route = RequestRoute.forgotPassword;
    final headers = await HeaderBuilder.completeAppHeaders(
        RequestRoute.forgotPassword, RequestMethod.post, null, null);
    final url = Uri.parse("$_serverHost$route");
    final body = jsonEncode({
      "todo": "todo",
    });
    final response = await _client.post(url, headers: headers, body: body);
    print(response.statusCode);
    print(response.body);
  }

  static Future<void> resetPassword() async {
    const route = RequestRoute.resetPassword;
    final headers = await HeaderBuilder.completeAppHeaders(
        RequestRoute.resetPassword, RequestMethod.post, null, null);
    final url = Uri.parse("$_serverHost$route");
    final body = jsonEncode({
      "todo": "todo",
    });
    final response = await _client.post(url, headers: headers, body: body);
    print(response.statusCode);
    print(response.body);
  }

  static Future<void> changePassword() async {
    const route = RequestRoute.changePassword;
    final headers = await HeaderBuilder.completeAppHeaders(
        RequestRoute.changePassword, RequestMethod.put, null, null);
    final url = Uri.parse("$_serverHost$route");
    final body = jsonEncode({
      "todo": "todo",
    });
    final response = await _client.put(url, headers: headers, body: body);
    print(response.statusCode);
    print(response.body);
  }

  static Future<void> collections() async {
    // 首页推荐
    const route = RequestRoute.collections;
    final headers = await HeaderBuilder.completeAppHeaders(
        RequestRoute.collections, RequestMethod.get, null, null);
    final url = Uri.parse("$_serverHost$route");
    final response = await _client.get(url, headers: headers);
    print(response.statusCode);
    print(response.body);
  }

  static Future<ApiResponse<CategoryResponseData>> categories() async {
    // 分类
    const route = RequestRoute.categories;
    final token = Account.shared.currentAccount?.token;
    final headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Host": "picaapi.picacomic.com",
    };
    final completeHeaders = await HeaderBuilder.completeAppHeaders(
        RequestRoute.categories, RequestMethod.get, token, headers);

    final url = Uri.parse("$_serverHost$route");
    final response = await _client.get(url, headers: completeHeaders);
    BikaLogger().d(response.body);
    final fuck = ApiResponse<CategoryResponseData>.fromJson(
        jsonDecode(response.body),
        (json) => CategoryResponseData.fromJson(json as Map<String, dynamic>));
    return fuck;
  }

  static Future<void> knightBoard() async {
    // 骑士榜
    const route = RequestRoute.knightBoard;
    final headers = await HeaderBuilder.completeAppHeaders(
        RequestRoute.knightBoard, RequestMethod.get, null, null);
    final url = Uri.parse("$_serverHost$route");
    final response = await _client.get(url, headers: headers);
    print(response.statusCode);
    print(response.body);
  }

  static Future<void> leaderboard() async {
    // 排行榜
    const route = RequestRoute.leaderboard;
    final headers = await HeaderBuilder.completeAppHeaders(
        RequestRoute.leaderboard, RequestMethod.get, null, null);
    final url = Uri.parse("$_serverHost$route");
    final response = await _client.get(url, headers: headers);
    print(response.statusCode);
    print(response.body);
  }

  static Future<void> comics() async {
    // 漫画列表
    const route = RequestRoute.comics;
    final headers = await HeaderBuilder.completeAppHeaders(
        RequestRoute.comics, RequestMethod.get, null, null);
    final url = Uri.parse("$_serverHost$route");
    final response = await _client.get(url, headers: headers);
    print(response.statusCode);
    print(response.body);
  }

  static Future<void> searchComics() async {
    // 搜索漫画
    const route = RequestRoute.searchComics;
    final headers = await HeaderBuilder.completeAppHeaders(
        RequestRoute.searchComics, RequestMethod.post, null, null);
    final url = Uri.parse("$_serverHost$route");
    final body = jsonEncode({
      "keyword": "keyword",
    });
    final response = await _client.post(url, headers: headers, body: body);
    print(response.statusCode);
    print(response.body);
  }

  static Future<void> hotKeywords() async {
    // 热搜词条
    const route = RequestRoute.hotKeywords;
    final headers = await HeaderBuilder.completeAppHeaders(
        RequestRoute.hotKeywords, RequestMethod.get, null, null);
    final url = Uri.parse("$_serverHost$route");
    final response = await _client.get(url, headers: headers);
    print(response.statusCode);
    print(response.body);
  }

  static Future<void> randomComics() async {
    // 随机漫画
    const route = RequestRoute.randomComics;
    final headers = await HeaderBuilder.completeAppHeaders(
        RequestRoute.randomComics, RequestMethod.get, null, null);
    final url = Uri.parse("$_serverHost$route");
    final response = await _client.get(url, headers: headers);
    print(response.statusCode);
    print(response.body);
  }

  static Future<void> selfProfile() async {
    const route = RequestRoute.selfProfile;
    final headers = await HeaderBuilder.completeAppHeaders(
        RequestRoute.selfProfile, RequestMethod.get, null, null);
    final url = Uri.parse("$_serverHost$route");
    final response = await _client.get(url, headers: headers);
    print(response.statusCode);
    print(response.body);
  }

  static const _initHost = "http://68.183.234.72/";

  static Future<ApiResponse<ServerInitResponseData>> nodeinfo() async {
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
