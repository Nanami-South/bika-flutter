import 'package:bika/src/api/response/profile.dart';
import 'package:bika/src/base/logger.dart';
import 'package:bika/src/theme/color.dart';
import 'package:bika/src/api/profile.dart';
import 'punch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserInfoAreaWidget extends StatefulWidget {
  const UserInfoAreaWidget({super.key});

  @override
  State<UserInfoAreaWidget> createState() => _UserInfoAreaWidgetState();
}

class _UserInfoAreaWidgetState extends State<UserInfoAreaWidget> {
  User? _user;
  bool _isLoading = false;

  void refreshUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final c = await ProfileApi.selfProfile();
      if (c != null) {
        if (mounted) {
          setState(() {
            _user = c.user;
          });
        }
      } else {
        BikaLogger().e('user is null');
      }
    } catch (e) {
      BikaLogger().e(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    refreshUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      if (_isLoading)
        _buildLoading(context)
      else if (_user == null)
        _buildError(context)
      else
        _buildUserInfoArea(context),
    ]);
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryColor(context),
          ),
          const SizedBox(height: 10),
          const Text('加载中...',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          const Text('网络请求失败',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 10),
          TextButton(
              onPressed: () {
                refreshUserProfile();
              },
              child: Text('点击重试',
                  style: TextStyle(
                      color: AppColors.primaryColor(context), fontSize: 16)))
        ],
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryColor(context).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: _user!.avatar?.imageUrl() ?? '',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 50),
          fadeOutDuration: const Duration(milliseconds: 50),
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor(context),
                strokeWidth: 1,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.broken_image,
              color: Colors.grey,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 左侧等级和头像
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor(context).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    Text(
                      'Lv.${_user!.level}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _user!.title ?? '暂无称号',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.primaryColor(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ])),
              const SizedBox(height: 8),
              _buildUserAvatar(context),
            ],
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _user!.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _user!.slogan ?? '这个人很懒，还没有写个性签名~',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // 打卡
          PunchInWidget(initialPunchState: _user!.isPunched),
        ],
      ),
    );
  }
}
