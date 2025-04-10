import 'package:bika/src/model/account.dart';
import 'package:bika/src/theme/color.dart';
import 'package:bika/src/views/login.dart';
import 'package:bika/src/views/profile/profile.dart';
import 'package:bika/src/views/search/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatefulWidget {
  static const String routeName = '/';
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

enum HomeBottomBarType {
  search,
  profile;

  String get displayName {
    switch (this) {
      case HomeBottomBarType.search:
        return "发现";
      case HomeBottomBarType.profile:
        return "我的";
    }
  }

  IconData get icon {
    switch (this) {
      case HomeBottomBarType.search:
        return Icons.search;
      case HomeBottomBarType.profile:
        return Icons.person;
    }
  }
}

class BottomBarTools {
  static const _bottomBarTypeList = HomeBottomBarType.values;
  static const defaultBottomBarType = HomeBottomBarType.search;

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
      BottomBarTools.indexOfBottomBarType(HomeBottomBarType.search));

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
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor(context)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    type.icon,
                    size: 20,
                    color: isSelected
                        ? AppColors.onPrimaryColor(context)
                        : AppColors.onSurfaceColor(context),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  type.displayName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? AppColors.primaryColor(context)
                        : AppColors.onSurfaceColor(context),
                  ),
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
      case HomeBottomBarType.search:
      case HomeBottomBarType.profile:
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
          padding: EdgeInsets.zero,
          color: AppColors.backgroundColor(context),
          height: 64,
          child: Row(
            children: bottomBarItems,
          ),
        );
      },
    );
  }

  final _tabWidgetKeys = [
    GlobalKey<SearchWidgetState>(),
    GlobalKey<ProfileWidgetState>(),
  ];
  List<Widget> _tabWidgetList() {
    return [
      SearchWidget(key: _tabWidgetKeys[0]),
      ProfileWidget(key: _tabWidgetKeys[1]),
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
