import 'package:bika/src/views/comic/list/card.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/api/response/comics.dart';
import 'package:bika/src/api/comics.dart';
import 'package:bika/src/base/logger.dart';

class RankComicPageWidget extends StatefulWidget {
  const RankComicPageWidget({super.key});

  @override
  State<RankComicPageWidget> createState() => _RankComicPageWidgetState();
}

class _RankComicPageWidgetState extends State<RankComicPageWidget>
    with SingleTickerProviderStateMixin {
  final Map<TimeType, List<ComicDoc>> _cachedRankList = {};
  late TabController _tabController;

  final List<String> _tabs = ['日榜', '周榜', '月榜'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      _onTabChanged(_tabController.index);
    });
    _loadRankList(TimeType.day);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadRankList(TimeType timeType, {bool allowCache = true}) {
    if (allowCache && _cachedRankList[timeType] != null) {
      return;
    }
    try {
      ComicsApi.hotLeaderboard(timeType: timeType).then((value) {
        setState(() {
          _cachedRankList[timeType] = value?.comics ?? [];
        });
      });
    } catch (e) {
      BikaLogger().e(e.toString());
    }
  }

  void _onTabChanged(int index) {
    switch (index) {
      case 0:
        _loadRankList(TimeType.day);
        break;
      case 1:
        _loadRankList(TimeType.week);
        break;
      case 2:
        _loadRankList(TimeType.month);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("排行榜"),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRankList(context, TimeType.day),
          _buildRankList(context, TimeType.week),
          _buildRankList(context, TimeType.month),
        ],
      ),
    );
  }

  Widget _buildRankList(BuildContext context, TimeType timeType) {
    if (_cachedRankList[timeType]?.isEmpty ?? true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: _cachedRankList[timeType]?.length ?? 0,
      itemBuilder: (context, index) {
        final comic = _cachedRankList[timeType]![index];
        return ComicListCardWidget(comic: comic);
      },
    );
  }
}
