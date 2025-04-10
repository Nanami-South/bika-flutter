import 'package:bika/src/base/logger.dart';
import 'package:bika/src/theme/color.dart';
import 'package:bika/src/views/toast.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/api/comics.dart';

class SettingWidget extends StatefulWidget {
  static const String routeName = '/setting';
  const SettingWidget({super.key});

  @override
  State<SettingWidget> createState() => SettingWidgetState();
}

class SettingWidgetState extends State<SettingWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor(context),
        surfaceTintColor: AppColors.backgroundColor(context),
      ),
      backgroundColor: AppColors.backgroundColor(context),
      body: _buildBody(context),
    );
  }

  final List<Map<String, dynamic>> apiTests = [
    {'name': '收藏列表', 'action': () => _testApi('收藏列表')},
    {'name': '热门榜(24h)', 'action': () => _testApi('热门榜(24h)')},
    {'name': '随机漫画', 'action': () => _testApi('随机漫画')},
    {'name': '标签搜索', 'action': () => _testApi('标签搜索')},
    {'name': '作者搜索', 'action': () => _testApi('作者搜索')},
    {'name': '汉化组搜索', 'action': () => _testApi('汉化组搜索')},
    {'name': '创作者搜索', 'action': () => _testApi('创作者搜索')},
    {'name': '漫画详情', 'action': () => _testApi('漫画详情')},
    {'name': '漫画推荐', 'action': () => _testApi('漫画推荐')},
    {'name': '漫画章节', 'action': () => _testApi('漫画章节')},
    {'name': '漫画图片', 'action': () => _testApi('漫画图片')},
  ];

  static void _testApi(String name) async {
    // 模拟 API 调用

    // 收藏列表接口
    try {
      if (name == '收藏列表') {
        const sortType = SortType.dateDescend;
        const page = "1";
        final pagedComicsListData = await ComicsApi.myLatestFavoriteComics(
            sortType: sortType, page: page);
        GlobalToast.show('收藏列表',
            debugMessage:
                "comics list: pages=${pagedComicsListData?.comics.pages}, total=${pagedComicsListData?.comics.total}, docs len=${pagedComicsListData?.comics.docs.length}");
      }
      if (name == '热门榜(24h)') {
        const timeType = TimeType.day;
        final comicListData =
            await ComicsApi.hotLeaderboard(timeType: timeType);
        GlobalToast.show('热门榜(24h)',
            debugMessage:
                "hot leader board(24h) comics: length=${comicListData?.comics.length}");
      }
      if (name == '随机漫画') {
        final comicListData = await ComicsApi.randomComics();
        GlobalToast.show('随机漫画',
            debugMessage:
                "random comics: length=${comicListData?.comics.length}");
      }
      if (name == '标签搜索') {
        final pagedComicsListData =
            await ComicsApi.comicsWithTags("NTR", "1", SortType.dateDescend);
        GlobalToast.show('标签搜索',
            debugMessage:
                "comics list: pages=${pagedComicsListData?.comics.pages}, total=${pagedComicsListData?.comics.total}, docs len=${pagedComicsListData?.comics.docs.length}");
      }
      if (name == '作者搜索') {
        final pagedComicsListData =
            await ComicsApi.comicsWithAuthor("三色坊", "1", SortType.dateDescend);
        GlobalToast.show('作者搜索',
            debugMessage:
                "comics list: pages=${pagedComicsListData?.comics.pages}, total=${pagedComicsListData?.comics.total}, docs len=${pagedComicsListData?.comics.docs.length}");
      }
      if (name == '汉化组搜索') {
        final pagedComicsListData = await ComicsApi.comicsWithChineseTeam(
            "无毒汉化组", "1", SortType.dateDescend);
        GlobalToast.show('汉化组搜索',
            debugMessage:
                "comics list: pages=${pagedComicsListData?.comics.pages}, total=${pagedComicsListData?.comics.total}, docs len=${pagedComicsListData?.comics.docs.length}");
      }
      if (name == '创作者搜索') {
        // TODO: 暂时不知道 ca 传什么
      }
      if (name == '漫画详情') {
        final comicInfo = await ComicsApi.comicInfo("582196995f6b9a4f93e8124b");
        GlobalToast.show('漫画详情',
            debugMessage:
                "comicInfo: id=${comicInfo?.comic.id}, title=${comicInfo?.comic.title}, author=${comicInfo?.comic.author}");
      }
      if (name == '漫画推荐') {
        final comicsListData =
            await ComicsApi.recommendComicList("582196995f6b9a4f93e8124b");
        GlobalToast.show('漫画推荐',
            debugMessage:
                "recommend comics: length=${comicsListData?.comics.length}");
      }
      if (name == '漫画章节') {
        final episodeData =
            await ComicsApi.comicEpisodeData("582196995f6b9a4f93e8124b", "1");
        GlobalToast.show('漫画章节',
            debugMessage:
                "comic episode: length=${episodeData?.eps.docs}, total=${episodeData?.eps.total}");
      }
      if (name == '漫画图片') {
        final comicPicturesData = await ComicsApi.comicPictureData(
            "582196995f6b9a4f93e8124b", 1, "1");
        GlobalToast.show('漫画图片',
            debugMessage:
                "comic picture data: ep title=${comicPicturesData?.ep.title}, total=${comicPicturesData?.pages.total}");
      }
    } catch (e) {
      BikaLogger().e(e.toString());
    } finally {}
  }

  Widget _buildTestApiButtonList(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: apiTests.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: ElevatedButton(
              onPressed: apiTests[index]['action'],
              child: Text(apiTests[index]['name']),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTestApiButtonList(context),
          Divider(
            thickness: 1,
            color: AppColors.onSurfaceColor(context),
            indent: 4,
            endIndent: 4,
          ),
        ],
      ),
    );
  }
}
