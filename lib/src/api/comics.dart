import 'client.dart';
import 'response/action.dart';
import 'response/comics.dart';

enum SortType {
  // "dd" 新到旧, "da" 旧到新, "ld" 最多爱心, "vd" 最多指名
  dateDescend("dd"),
  dateAscend("da"),
  likeDescend("ld"),
  viewDescend("vd");

  final String value;
  const SortType(this.value);

  String display() {
    switch (this) {
      case SortType.dateDescend:
        return '新到旧';
      case SortType.dateAscend:
        return '旧到新';
      case SortType.likeDescend:
        return '最多爱心';
      case SortType.viewDescend:
        return '最多指名';
      default:
        return '未知值: $value';
    }
  }
}

enum TimeType {
  day("H24"),
  week("D7"),
  month("D30");

  final String value;
  const TimeType(this.value);

  String display() {
    switch (this) {
      case TimeType.day:
        return '日';
      case TimeType.week:
        return '周';
      case TimeType.month:
        return '月';
      default:
        return '未知值: $value';
    }
  }
}

class ComicsApi {
  static Future<ComicsListResponseData?> _hotLeaderboard(
      TimeType timeType) async {
    final queryParams = {
      "tt": timeType.value, // tt=H24 D7 D30
      "ct": "VC",
    };
    final response = await HttpClient.get<ComicsListResponseData>(
        route: "comics/leaderboard",
        fromJsonT: ComicsListResponseData.fromJson,
        queryParams: queryParams,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  /// 查看热门排行榜
  static Future<ComicsListResponseData?> hotLeaderboard(
      {TimeType timeType = TimeType.day}) async {
    return _hotLeaderboard(timeType);
  }

  static Future<PagedComicsListResponseData?> _myFavoriteComics(
      SortType s, String page) async {
    final queryParams = {
      "s": s.value,
      "page": page,
    };
    final response = await HttpClient.get<PagedComicsListResponseData>(
        route: "users/favourite",
        fromJsonT: PagedComicsListResponseData.fromJson,
        queryParams: queryParams,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  /// 查看我的收藏列表
  static Future<PagedComicsListResponseData?> myLatestFavoriteComics({
    SortType sortType = SortType.dateDescend,
    String page = "1",
  }) async {
    return _myFavoriteComics(sortType, page);
  }

  /// 收藏漫画
  static Future<ActionResponseData?> favoriteComic(String id) async {
    final response = await HttpClient.post<ActionResponseData>(
        route: "comics/$id/favourite",
        fromJsonT: ActionResponseData.fromJson,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  /// 点赞漫画
  static Future<ActionResponseData?> likeComic(String id) async {
    final response = await HttpClient.post<ActionResponseData>(
        route: "comics/$id/like",
        fromJsonT: ActionResponseData.fromJson,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  static Future<PagedComicsListResponseData?> _comicsListWithCondition(
      Map<String, String> condition, String page) async {
    // 条件查询漫画列表
    final queryParams = condition;
    final response = await HttpClient.get<PagedComicsListResponseData>(
        route: "comics",
        fromJsonT: PagedComicsListResponseData.fromJson,
        queryParams: queryParams,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  /// 按标签搜索
  static Future<PagedComicsListResponseData?> comicsWithTags(
      String tags, String page, SortType sortType) async {
    // 按照标签搜索
    final queryParams = {
      "t": tags,
      "s": sortType.value,
      "page": page,
    };
    return _comicsListWithCondition(queryParams, page);
  }

  /// 按分类搜索
  static Future<PagedComicsListResponseData?> comicsWithCategory(
      String category, String page, SortType sortType) async {
    // 按照分类搜索
    final queryParams = {
      "c": category,
      "s": sortType.value,
      "page": page,
    };
    return _comicsListWithCondition(queryParams, page);
  }

  /// 按作者搜索
  static Future<PagedComicsListResponseData?> comicsWithAuthor(
      String author, String page, SortType sortType) async {
    // 查询某个作者的作品列表
    final queryParams = {
      "a": author,
      "s": sortType.value,
      "page": page,
    };
    return _comicsListWithCondition(queryParams, page);
  }

  /// 按翻译搜索
  static Future<PagedComicsListResponseData?> comicsWithChineseTeam(
      String ct, String page, SortType sortType) async {
    // 按照汉化组搜索
    final queryParams = {
      "ct": ct,
      "s": sortType.value,
      "page": page,
    };
    return _comicsListWithCondition(queryParams, page);
  }

  /// 按上传者搜索
  static Future<PagedComicsListResponseData?> comicsWithCreator(
      String ca, String page, SortType sortType) async {
    // 按照创作者搜索
    final queryParams = {
      "ca": ca,
      "s": sortType.value,
      "page": page,
    };
    return _comicsListWithCondition(queryParams, page);
  }

  /// 按最新搜索
  static Future<PagedComicsListResponseData?> latestComics(String page) async {
    // 按照最新搜索
    final queryParams = {
      "s": SortType.dateDescend.value,
      "page": page,
    };
    return _comicsListWithCondition(queryParams, page);
  }

  /// 随机漫画
  static Future<ComicsListResponseData?> randomComics() async {
    final response = await HttpClient.get<ComicsListResponseData>(
        route: "comics/random",
        fromJsonT: ComicsListResponseData.fromJson,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  /// 漫画详情
  static Future<ComicInfoResponseData?> comicInfo(String id) async {
    final response = await HttpClient.get<ComicInfoResponseData>(
        route: "comics/$id",
        fromJsonT: ComicInfoResponseData.fromJson,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  /// 漫画详情页的推荐
  static Future<ComicsListResponseData?> recommendComicList(String id) async {
    final response = await HttpClient.get<ComicsListResponseData>(
        route: "comics/$id/recommendation",
        fromJsonT: ComicsListResponseData.fromJson,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  /// 漫画章节数据
  static Future<ComicEpisodeResponseData?> comicEpisodeData(
      String id, String page) async {
    final response = await HttpClient.get<ComicEpisodeResponseData>(
        route: "comics/$id/eps",
        fromJsonT: ComicEpisodeResponseData.fromJson,
        queryParams: {
          "page": page,
        },
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  /// 漫画章节的图片数据
  static Future<ComicPictureResponseData?> comicPictureData(
      String id, int order, String page) async {
    final response = await HttpClient.get<ComicPictureResponseData>(
        route: "comics/$id/order/$order/pages",
        fromJsonT: ComicPictureResponseData.fromJson,
        queryParams: {
          "page": page,
        },
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }
}
