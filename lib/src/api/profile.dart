import 'client.dart';
import 'response/base.dart';
import 'response/profile.dart';
import 'response/punchin.dart';

class ProfileApi {
  static Future<ProfileData?> selfProfile() async {
    // 查看自己的 profile
    final response = await HttpClient.get<ProfileData>(
        route: "users/profile",
        fromJsonT: ProfileData.fromJson,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  static Future<ProfileData?> userProfile(String userId) async {
    // 查看别人的 profile
    final response = await HttpClient.get<ProfileData>(
        route: "users/$userId/profile",
        fromJsonT: ProfileData.fromJson,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data;
  }

  static Future<EmptyData> updateSlogan(String slogan) async {
    // 更新个性签名
    final body = {"slogan": slogan};
    final response = await HttpClient.put<EmptyData>(
        route: "users/profile",
        fromJsonT: EmptyData.fromJson,
        body: body,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data!;
  }

  static Future<EmptyData> updateAvatar(String avatarBase64) async {
    // 更新头像, 上传的分辨率是200x200
    final body = {"avatar": avatarBase64};
    final response = await HttpClient.put<EmptyData>(
        route: "users/avatar",
        fromJsonT: EmptyData.fromJson,
        body: body,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data!;
  }

  static Future<PunchInData> punchIn() async {
    // 打卡
    final response = await HttpClient.post<PunchInData>(
        route: "users/punch-in",
        fromJsonT: PunchInData.fromJson,
        withToken: true);
    if (response.code != 200) {
      throw Exception(response.message);
    }
    return response.data!;
  }
}
