import 'dart:convert';
import 'request/header.dart';
import 'request/method.dart';
import 'response/base.dart';
import 'package:bika/src/model/account.dart';
import 'package:bika/src/base/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

enum AppHost {
  mainServer("https://picaapi.picacomic.com/"),
  nodeConfig("http://68.183.234.72/");

  final String value;

  const AppHost(this.value);

  @override
  String toString() => value;
}

class HttpClient {
  static final _client = http.Client();

  static Future<ApiResponse<T>> _request<T>({
    required AppHost host,
    required RequestMethod method,
    required String route,
    required T Function(Map<String, dynamic>) fromJsonT,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams, // get 请求有
    bool withToken = false,
  }) async {
    late Uri url;
    if (host == AppHost.mainServer) {
      // 这里先写死ip, 等nodeConfig的逻辑写了之后去掉
      url = Uri.parse("http://104.20.180.50/$route");
    } else {
      url = Uri.parse("${host.value}$route");
    }
    late String routeAndQuery;
    if (queryParams != null) {
      // 如果有 query 参数，拼接到 URL
      url = url.replace(queryParameters: queryParams);
      routeAndQuery = "$route?${url.query}";
    } else {
      routeAndQuery = route;
    }
    final token = withToken ? Account.shared.currentAccount?.token : null;
    final extraHeaders = {
      "Content-Type": "application/json; charset=UTF-8",
      "Host": "picaapi.picacomic.com",
    };
    final headers = await AppHeaderBuilder.completeAppHeaders(
        routeAndQuery, method, token, extraHeaders);

    late final http.Response response;
    switch (method) {
      case RequestMethod.get:
        response = await _client.get(url, headers: headers).timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException('请求超时');
          },
        );
      case RequestMethod.post:
        response = await _client
            .post(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        )
            .timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException('请求超时');
          },
        );
      case RequestMethod.put:
        response = await _client
            .put(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        )
            .timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException('请求超时');
          },
        );
      default:
        throw Exception("Unsupported method: $method");
    }
    BikaLogger().d(response.body);
    final apiResponse = ApiResponse<T>.fromJson(jsonDecode(response.body),
        (json) => fromJsonT(json as Map<String, dynamic>));

    if (apiResponse.isTokenExpired()) {
      Account.shared.logout();
    }
    return apiResponse;
  }

  static Future<ApiResponse<T>> get<T>({
    required String route,
    required T Function(Map<String, dynamic>) fromJsonT,
    Map<String, String>? queryParams,
    bool withToken = false,
  }) async {
    return _request(
        host: AppHost.mainServer,
        method: RequestMethod.get,
        route: route,
        fromJsonT: fromJsonT,
        queryParams: queryParams,
        withToken: withToken);
  }

  static Future<ApiResponse<T>> post<T>({
    required String route,
    required T Function(Map<String, dynamic>) fromJsonT,
    Map<String, dynamic>? body,
    bool withToken = false,
  }) async {
    return _request(
        host: AppHost.mainServer,
        method: RequestMethod.post,
        route: route,
        fromJsonT: fromJsonT,
        body: body,
        withToken: withToken);
  }

  static Future<ApiResponse<T>> put<T>({
    required String route,
    required T Function(Map<String, dynamic>) fromJsonT,
    Map<String, dynamic>? body,
    bool withToken = false,
  }) async {
    return _request(
        host: AppHost.mainServer,
        method: RequestMethod.put,
        route: route,
        fromJsonT: fromJsonT,
        body: body,
        withToken: withToken);
  }
}
