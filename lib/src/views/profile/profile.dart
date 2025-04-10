import 'package:bika/src/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/views/profile/userinfo/userinfo.dart';
import 'package:bika/src/views/profile/comic/favorite.dart';
import 'package:bika/src/model/account.dart';
import 'package:bika/src/views/login.dart';

class ProfileWidget extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => ProfileWidgetState();
}

class ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor(context))),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor(context),
        surfaceTintColor: AppColors.backgroundColor(context),
      ),
      backgroundColor: AppColors.backgroundColor(context),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UserInfoAreaWidget(),
          Divider(
            thickness: 1,
            color: AppColors.onSurfaceColor(context),
            indent: 4,
            endIndent: 4,
          ),
          const FavoriteComicsPreviewWidget(),
          const SizedBox(height: 36),
          // 退出登录按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceColor(context),
                foregroundColor: AppColors.primaryColor(context),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: AppColors.primaryColor(context),
                    width: 1,
                  ),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.pink[400],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '退出登录',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          '取消',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.pink[100],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Account.shared.logout();
                          Navigator.of(context)
                              .pushReplacementNamed(LoginWidget.routeName);
                        },
                        child: Text(
                          '确定',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.pink[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    actionsPadding:
                        const EdgeInsets.only(bottom: 16, right: 16),
                  ),
                );
              },
              child: const Text('退出登录'),
            ),
          ),
        ],
      ),
    );
  }
}
