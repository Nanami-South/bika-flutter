import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'package:bika/src/base/logger.dart';

class SignatureTool {
  // Calculate the signature of the request

  static const List<String> charTable = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f'
  ];

  // Main method to calculate HMAC-SHA256
  static Future<String?> sign(String str) async {
    const String keyString =
        r"~d}$Q7$eIni=V)9\RK/P.RM4;9[7|@/CA}b~OW!3?EV`:<>M7pddUBL5n|0/*Cn"; // bika 这个密钥是63位，感觉像是没注意转义符留下的坑
    final keyBytes = utf8.encode(keyString); // Convert key string to bytes
    // Convert input string to lowercase
    final dataStr = str.toLowerCase();
    final dataBytes = utf8.encode(dataStr);
    try {
      // HMAC-SHA256
      final hmac = Hmac(sha256, keyBytes);
      return hmac.convert(dataBytes).toString();
    } catch (e) {
      BikaLogger().e(e);
      return null;
    }
  }

  static Future<String> generateNonce() async {
    return const Uuid().v4().replaceAll('-', '');
  }
}
