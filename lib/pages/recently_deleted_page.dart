import 'package:flutter/material.dart';
import 'dart:io';

class RecentlyDeletedPage extends StatefulWidget {
  const RecentlyDeletedPage({super.key});

  @override
  _RecentlyDeletedPageState createState() => _RecentlyDeletedPageState();

  // 定义静态变量和方法
  static final List<Map<String, String>> _recentlyDeletedCards = [];

  static void addRecentlyDeletedCard(Map<String, String> card) {
    _recentlyDeletedCards.insert(0, card); // 将卡片添加到列表的最前面
  }
}

class _RecentlyDeletedPageState extends State<RecentlyDeletedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('最近删除'),
      ),
      body: ListView.builder(
        itemCount: RecentlyDeletedPage._recentlyDeletedCards.length,
        itemBuilder: (context, index) {
          final card = RecentlyDeletedPage._recentlyDeletedCards[index];
          return ListTile(
            title: Text(card['name']!),
            leading: Image.file(File(card['imagePath']!)),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  RecentlyDeletedPage._recentlyDeletedCards
                      .removeAt(index); // 从列表中移除卡片
                });
              },
            ),
          );
        },
      ),
    );
  }
}
