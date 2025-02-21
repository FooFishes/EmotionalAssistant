import 'package:flutter/material.dart';
import 'dart:io';
import 'mood_card_page.dart';

class CardPage extends StatefulWidget {
  final String cardName;
  final String imagePath;

  const CardPage({
    Key? key,
    required this.cardName,
    required this.imagePath,
  }) : super(key: key);

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  List<Map<String, String>> _moodCards = [];
  Color _backgroundColor = Colors.white;

  void _addOrUpdateMoodCard(String mood, String imagePath, {int? index}) {
    if (index == null) {
      // 添加新卡片
      setState(() {
        _moodCards.add({
          'mood': mood,
          'timestamp': DateTime.now().toString(),
          'imagePath': imagePath,
        });
      });
    } else {
      // 更新现有卡片
      setState(() {
        _moodCards[index] = {
          'mood': mood,
          'timestamp': _moodCards[index]['timestamp']!,
          'imagePath': imagePath,
        };
      });
    }
  }

  void _changeBackgroundColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择背景颜色'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Text('选择一种颜色：'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    buildColorChoiceIcon(Color(0xFFFFE0E0)), // Light Red
                    buildColorChoiceIcon(Color(0xFFFFE080)), // Light Yellow
                    buildColorChoiceIcon(Color(0xFFE0FFE0)), // Light Green
                    buildColorChoiceIcon(Color(0xFFE0E0FF)), // Light Blue
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildColorChoiceIcon(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _backgroundColor = color;
        });
        Navigator.of(context).pop();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color:
                _backgroundColor == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cardName),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: _changeBackgroundColor,
            tooltip: '更改背景颜色',
          ),
        ],
      ),
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.file(
                    File(widget.imagePath),
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.cardName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_moodCards.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: _moodCards.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: _moodCards[index]['imagePath'] != null
                          ? Image.file(
                              File(_moodCards[index]['imagePath']!),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : null,
                      title: Text(_moodCards[index]['mood']!),
                      subtitle: Text(_moodCards[index]['timestamp']!),
                      onTap: () {
                        // 跳转到 MoodCardPage 并传递当前卡片的数据
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoodCardPage(
                              onMoodAdded: (mood, imagePath) {
                                _addOrUpdateMoodCard(mood, imagePath,
                                    index: index);
                              },
                              initialMood: _moodCards[index]['mood']!,
                              initialImagePath: _moodCards[index]['imagePath']!,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            else
              const Center(
                child: Text('还没有心情卡片，点击右下角的加号添加吧！'),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoodCardPage(
                onMoodAdded: _addOrUpdateMoodCard,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
