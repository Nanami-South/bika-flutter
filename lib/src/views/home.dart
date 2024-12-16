import 'package:bika/src/model/account.dart';
import 'package:bika/src/theme/color.dart';
import 'package:bika/src/views/game/game.dart';
import 'package:bika/src/views/login.dart';
import 'package:bika/src/views/notice/notice.dart';
import 'package:bika/src/views/profile/profile.dart';
import 'package:bika/src/views/search/search.dart';
import 'package:bika/src/views/setting/setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatefulWidget {
  static const String routeName = '/';
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

enum HomeBottomBarType {
  notice,
  search,
  game,
  profile,
  setting;

  String get displayName {
    switch (this) {
      case HomeBottomBarType.notice:
        return "公告";
      case HomeBottomBarType.search:
        return "发现";
      case HomeBottomBarType.game:
        return "游戏";
      case HomeBottomBarType.profile:
        return "我的";
      case HomeBottomBarType.setting:
        return "设置";
    }
  }

  IconData get icon {
    switch (this) {
      case HomeBottomBarType.notice:
        return Icons.home;
      case HomeBottomBarType.search:
        return Icons.search;
      case HomeBottomBarType.game:
        return Icons.games;
      case HomeBottomBarType.profile:
        return Icons.person;
      case HomeBottomBarType.setting:
        return Icons.settings;
    }
  }
}

class BottomBarTools {
  static const _bottomBarTypeList = HomeBottomBarType.values;
  static const defaultBottomBarType = HomeBottomBarType.notice;

  static int indexOfBottomBarType(HomeBottomBarType type) {
    return _bottomBarTypeList.indexOf(type);
  }

  static HomeBottomBarType bottomBarTypeOfIndex(int index) {
    return _bottomBarTypeList[index];
  }
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late final ValueNotifier<int> _currentBottomBarIndexNotifier = ValueNotifier(
      BottomBarTools.indexOfBottomBarType(HomeBottomBarType.notice));

  Widget _buildBottomBarItem(
      int index, bool isSelected, HomeBottomBarType type) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          if (_currentBottomBarIndexNotifier.value != index) {
            _currentBottomBarIndexNotifier.value = index;
            return;
          }
        },
        child: Container(
          color:
              isSelected ? AppColors.primaryColor(context) : Colors.transparent,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(type.icon,
                    size: 30,
                    color: isSelected
                        ? AppColors.onPrimaryColor(context)
                        : AppColors.onSurfaceColor(context)),
                Text(
                  type.displayName,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.onPrimaryColor(context)
                          : AppColors.onSurfaceColor(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarOfType(HomeBottomBarType type) {
    final index = BottomBarTools.indexOfBottomBarType(type);
    final isSelected = _currentBottomBarIndexNotifier.value == index;
    switch (type) {
      // 将来这里可以走不通的tab构造逻辑，比如中心的按钮比较大
      case HomeBottomBarType.notice:
      case HomeBottomBarType.search:
      case HomeBottomBarType.game:
      case HomeBottomBarType.profile:
      case HomeBottomBarType.setting:
        return _buildBottomBarItem(
          index,
          isSelected,
          type,
        );
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _currentBottomBarIndexNotifier,
      builder: (context, index, child) {
        final bottomBarItems = BottomBarTools._bottomBarTypeList
            .map((type) => _buildBottomNavigationBarOfType(type))
            .toList();
        return BottomAppBar(
          padding: EdgeInsets.zero, // 去掉默认的padding
          color: AppColors.backgroundColor(context),
          height: 50,
          child: Row(
            children: bottomBarItems,
          ),
        );
      },
    );
  }

  final _tabWidgetKeys = [
    GlobalKey<NoticeWidgetState>(),
    GlobalKey<SearchWidgetState>(),
    GlobalKey<GameWidgetState>(),
    GlobalKey<ProfileWidgetState>(),
    GlobalKey<SettingWidgetState>(),
  ];
  List<Widget> _tabWidgetList() {
    return [
      NoticeWidget(key: _tabWidgetKeys[0]),
      SearchWidget(key: _tabWidgetKeys[1]),
      GameWidget(key: _tabWidgetKeys[2]),
      ProfileWidget(key: _tabWidgetKeys[3]),
      SettingWidget(key: _tabWidgetKeys[4]),
    ];
  }

  Widget _buildBody(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _currentBottomBarIndexNotifier,
        builder: (context, value, child) {
          final tabWidgets = _tabWidgetList();
          // 使用 IndexedStack 方便在不通tab之间切换的时候保存不同tab的状态
          return IndexedStack(
              index: value, children: [for (final w in tabWidgets) w]);
        });
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Account.shared),
      ],
      child: Consumer<Account>(builder: (context, account, child) {
        if (!account.isValidLogin()) {
          // 本地没有登陆的token状态，退出到登陆页面
          return const Scaffold(body: LoginWidget());
        }
        return Scaffold(
          resizeToAvoidBottomInset:
              true, // 弹出软键盘的时候，自动调节body区域的高度，使得底部高度刚好为键盘的高度
          bottomNavigationBar: _buildBottomNavigationBar(context),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: _buildBody(context),
          ),
        );
      }),
    );
  }
}
