import './method.dart';
import './signature.dart';

class AppHeaderBuilder {
  static const _apiKey = "C69BAF41DA5ABD1FFEDC6D2FEA56B";
  static Future<Map<String, String>> completeAppHeaders(
      String routeAndQuery,
      RequestMethod method,
      String? token,
      Map<String, String>? extraHeaders) async {
    // 比如 http://1.1.1.1/xxx/yyy?q=1 这里 routeAndQuery 是 xxx/yyy?q=1, queryParams 部分也是要参与签名计算的
    int timestampInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final timestamp = timestampInSeconds.toString();
    final nonce = await SignatureTool.generateNonce();
    final methodStr = method.value;
    final toSign = routeAndQuery + timestamp + nonce + methodStr + _apiKey;
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
}
