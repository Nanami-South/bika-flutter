import 'dart:convert';
import 'dart:typed_data';
import 'package:bika/src/svc/logger.dart';
import 'package:crypto/crypto.dart';

class SignatureTool {
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

  // Method to generate HMAC-SHA256 hash
  Future<String?> _sign(String str, Uint8List keyBytes) async {
    try {
      // Create Hmac instance with SHA256 algorithm and the key
      final hmac = Hmac(sha256, keyBytes);

      // Generate HMAC digest
      final List<int> digest = hmac.convert(utf8.encode(str)).bytes;

      final StringBuffer sb = StringBuffer();
      for (int byte in digest) {
        final high = (byte & 255) >>> 4;
        final low = byte & 0xF;

        sb
          ..write(charTable[high])
          ..write(charTable[low]);
      }

      return sb.toString();
    } catch (e) {
      BikaLogger().e(e.toString());
      return null;
    }
  }

  // Main method to calculate HMAC-SHA256
  Future<String?> sign(String str) async {
    const String keyString =
        r"~d}$Q7$eIni=V)9\\RK/P.RM4;9[7|@/CA}b~OW!3?EV`:<>M7pddUBL5n|0/*Cn";
    final keyBytes = utf8.encode(keyString); // Convert key string to bytes

    // Convert input string to lowercase
    final lowerCaseStr = str.toLowerCase();

    final signature = await _sign(lowerCaseStr, keyBytes);
    return signature;
  }
}
