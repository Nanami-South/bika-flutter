import 'package:bika/src/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:bika/src/views/profile/userinfo/userinfo.dart';
import 'package:bika/src/views/profile/comic/favorite.dart';

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
        title: const Text('我的'),
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
          const Text("TODO: 最近"),
          Divider(
            thickness: 1,
            color: AppColors.onSurfaceColor(context),
            indent: 4,
            endIndent: 4,
          ),
          const FavoriteComicsPreviewWidget(),
        ],
      ),
    );
  }
}
