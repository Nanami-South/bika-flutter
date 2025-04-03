import 'package:bika/src/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GlobalToast {
  static void show(String? message, {String? debugMessage}) {
    String? toastMessage;
    if (kDebugMode) {
      toastMessage = "$message\nDEBUG:${debugMessage ?? ""}";
    } else {
      toastMessage = message;
    }
    if (toastMessage?.isNotEmpty != true) {
      return;
    }
    double keyboardHeight = 0;
    if (gNavigatorKey.currentContext != null) {
      keyboardHeight = View.of(gNavigatorKey.currentContext!).viewInsets.bottom;
    }
    Fluttertoast.showToast(
      msg: toastMessage!,
      toastLength: Toast.LENGTH_LONG,
      gravity: keyboardHeight > 0 ? ToastGravity.CENTER : ToastGravity.BOTTOM,
    );
  }
}
