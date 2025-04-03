import 'package:bika/src/api/comics.dart';
import 'package:bika/src/api/response/comics.dart';
import 'package:bika/src/base/logger.dart';
import 'package:bika/src/views/comic/list/card.dart';
import 'package:flutter/material.dart';

class RandomComicPageWidget extends StatefulWidget {
  const RandomComicPageWidget({super.key});

  @override
  State<RandomComicPageWidget> createState() => _RandomComicPageWidgetState();
}

class _RandomComicPageWidgetState extends State<RandomComicPageWidget> {
  List<ComicDoc> _comicsList = [];

  void _loadRandomList() {
    try {
      ComicsApi.randomComics().then((value) {
        setState(() {
          _comicsList = value?.comics ?? [];
        });
      });
    } catch (e) {
      BikaLogger().e(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRandomList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("随机本子"),
        leading: const BackButton(), // 左上角返回按钮
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_comicsList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: _comicsList.length,
      itemBuilder: (context, index) {
        return ComicListCardWidget(comic: _comicsList[index]);
      },
    );
  }
}
