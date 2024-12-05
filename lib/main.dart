import 'package:bika/src/model/account.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/app.dart';

Future<void> beforeRunApp() async {
  // init some data
  await Account.shared.init();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final deviceSize = PlatformDispatcher.instance.displays.firstOrNull?.size;
  if (!kDebugMode && deviceSize != null) {
    if (deviceSize.width / deviceSize.height > 2 ||
        deviceSize.width / deviceSize.height < 0.5) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  await beforeRunApp();

  runApp(const MyApp());
}
