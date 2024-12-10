import 'package:bika/src/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bika/src/model/account.dart';
import 'package:bika/src/views/login.dart';
import 'package:bika/src/views/home.dart';

final GlobalKey<NavigatorState> gNavigatorKey = GlobalKey<NavigatorState>();

class BikaApp extends StatefulWidget {
  const BikaApp({super.key});

  @override
  State<BikaApp> createState() => _BikaAppState();
}

class _BikaAppState extends State<BikaApp> {
  late Widget _home;

  @override
  void initState() {
    super.initState();
    _home = const HomeWidget();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bika Flutter',
      navigatorKey: gNavigatorKey,
      theme: AppColors.lightTheme(),
      darkTheme: AppColors.darkTheme(),
      themeMode: ThemeMode.system,
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (context) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: Account.shared),
              ],
              child: Consumer<Account>(builder: (context, account, child) {
                if (account.currentAccount == null ||
                    account.currentAccount!.token == null) {
                  return const LoginWidget();
                }
                switch (routeSettings.name) {
                  case LoginWidget.routeName:
                    return const LoginWidget();
                  case HomeWidget.routeName:
                  default:
                    return _home;
                }
              }),
            );
          },
        );
      },
      builder: (context, child) {
        return child ?? _home;
      },
    );
  }
}
