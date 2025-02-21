import 'dart:io';
import 'package:flutter/material.dart';
import 'honey_page.dart';
import 'recently_deleted_page.dart';
import 'package:image_picker/image_picker.dart';
import 'card_page.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  _CollectionsPageState createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedImagePath = '';
  final ImagePicker _picker = ImagePicker();
  List<Widget> _cards = []; // 用于存储新建的卡片
  final List<Map<String, String>> _cardData = [];

  List<Map<String, String>> _searchResults = [];

  void _showCardMenu(int cardIndex) {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        const PopupMenuItem<String>(
          value: 'modifyName',
          child: Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 8),
              Text('修改卡片集名称'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'modifyCover',
          child: Row(
            children: [
              Icon(Icons.image),
              SizedBox(width: 8),
              Text('修改卡片集封面'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'pin',
          child: Row(
            children: [
              Icon(Icons.push_pin),
              SizedBox(width: 8),
              Text('置顶卡片集'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 8),
              Text('删除卡片集'),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        _onCardMenuSelected(value, cardIndex);
      }
    });
  }

  void _onCardMenuSelected(String value, int cardIndex) {
    switch (value) {
      case 'modifyName': // 修改卡片名称
        _showModifyNameDialog(cardIndex);
        break;
      case 'modifyCover': // 修改卡片封面
        _showModifyCoverDialog(cardIndex);
        break;
      case 'pin': // 置顶卡片
        _pinCard(cardIndex);
        break;
      case 'delete': // 删除卡片
        _deleteCard(cardIndex);
        break;
    }
  }

  void _showModifyNameDialog(int cardIndex) {
    TextEditingController newNameController = TextEditingController(
      text: _cardData[cardIndex]['name'],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('修改卡片名称'),
          content: TextField(
            controller: newNameController,
            decoration: const InputDecoration(labelText: '输入新的卡片名称'),
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
                if (newNameController.text.isNotEmpty) {
                  setState(() {
                    _cardData[cardIndex]['name'] = newNameController.text;
                    _cards = _cardData.asMap().entries.map((entry) {
                      return _buildCard(entry.key);
                    }).toList();
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showModifyCoverDialog(int cardIndex) {
    _pickImageOrTakePhoto().then((_) {
      if (_selectedImagePath.isNotEmpty) {
        setState(() {
          _cardData[cardIndex]['imagePath'] = _selectedImagePath;
          _selectedImagePath = ''; // 清空图片路径
          _cards = _cardData.asMap().entries.map((entry) {
            return _buildCard(entry.key);
          }).toList();
        });
      }
    });
  }

  void _pinCard(int cardIndex) {
    setState(() {
      final card = _cardData.removeAt(cardIndex);
      _cardData.insert(0, card);
      _cards = _cardData.asMap().entries.map((entry) {
        return _buildCard(entry.key);
      }).toList();
    });
  }

  void _deleteCard(int cardIndex) {
    final deletedCard = _cardData.removeAt(cardIndex); // 从数据列表中移除卡片
    setState(() {
      _cards.removeAt(cardIndex); // 从卡片列表中移除对应的卡片
    });

    // 将删除的卡片添加到最近删除页面的列表中
    RecentlyDeletedPage.addRecentlyDeletedCard(deletedCard);
  }

  Widget _buildCard(int cardIndex) {
    String name = _cardData[cardIndex]['name']!;
    String imagePath = _cardData[cardIndex]['imagePath']!;
    double cardWidth = 345; // 卡片宽度
    double cardHeight = 90; // 卡片高度
    double borderRadius = 10; // 圆角半径
    double cardLeft = 26; // 卡片左边距
    double cardTop = 374; // 卡片上边距

    for (int i = 0; i < cardIndex; i++) {
      cardTop += 90 + 10; // 每个卡片的高度为90，间距为10
    }

    return Positioned(
      key: ValueKey(cardIndex), // 使用 ValueKey 为每个卡片添加唯一标识
      top: cardTop,
      left: cardLeft,
      width: cardWidth,
      height: cardHeight,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CardPage(
                cardName: name,
                imagePath: imagePath,
              ),
            ),
          );
        },
        onLongPress: () {
          _showCardMenu(cardIndex);
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: const BorderSide(color: Colors.white, width: 1),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.white,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Image.file(
                    File(imagePath),
                    width: cardWidth * (1 / 3),
                    height: cardHeight,
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PopupMenuButton<String>(
                    onSelected: (String value) {
                      _onCardMenuSelected(value, cardIndex);
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'modifyName',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('修改卡片集名称'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'modifyCover',
                          child: Row(
                            children: [
                              Icon(Icons.image),
                              SizedBox(width: 8),
                              Text('修改卡片集封面'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'pin',
                          child: Row(
                            children: [
                              Icon(Icons.push_pin),
                              SizedBox(width: 8),
                              Text('置顶卡片集'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 8),
                              Text('删除卡片集'),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageOrTakePhoto() async {
    final ImageSource source = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('选择图片来源'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop(ImageSource.gallery);
              },
              child: const Text('从相册选择'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop(ImageSource.camera);
              },
              child: const Text('拍照'),
            ),
          ],
        );
      },
    );

    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  void _addCard() {
    if (_nameController.text.isNotEmpty && _selectedImagePath.isNotEmpty) {
      setState(() {
        _cardData.add({
          'name': _nameController.text,
          'imagePath': _selectedImagePath,
        });
        _cards = _cardData.asMap().entries.map((entry) {
          return _buildCard(entry.key);
        }).toList();
      });

      _nameController.clear();
      _selectedImagePath = '';
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入卡片名称并选择封面图片')),
      );
    }
  }

  void _showCardDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('新建卡片集'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '输入新建卡片集名称'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('上传卡片集封面'),
                  GestureDetector(
                    onTap: _pickImageOrTakePhoto,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _selectedImagePath.isNotEmpty
                          ? Image.file(File(_selectedImagePath))
                          : const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('取消'),
                  ),
                  ElevatedButton(
                    onPressed: _addCard,
                    child: const Text('完成'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // My updates
        const Positioned(
          top: 148,
          left: 25,
          child: Text(
            'My updates',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        // Collections
        const Positioned(
          top: 330,
          left: 25,
          child: Text(
            'Collections',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        //搜索框
        Positioned(
          child: Container(
            width: 326,
            height: 48,
            margin: const EdgeInsets.only(
              top: 73,
              left: 18,
            ),
            child: TextField(
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _searchResults = _cardData.where((card) {
                      return card['name']!
                          .toLowerCase()
                          .contains(value.toLowerCase());
                    }).toList();
                  });
                } else {
                  setState(() {
                    _searchResults = [];
                  });
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  top: 12,
                  right: 24,
                  bottom: 12,
                  left: 16,
                ),
                hintText: 'Search your card...',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
        // 搜索结果展示
        if (_searchResults.isNotEmpty)
          Positioned(
            top: 120,
            left: 20,
            width: 326,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]['name']!),
                  leading: Image.file(
                    File(_searchResults[index]['imagePath']!),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CardPage(
                          cardName: _searchResults[index]['name']!,
                          imagePath: _searchResults[index]['imagePath']!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        // 最近删除
        Positioned(
          top: 784,
          left: 13,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecentlyDeletedPage(),
                ),
              );
            },
            child: const SizedBox(
              width: 118,
              height: 34,
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.black),
                  SizedBox(width: 8),
                  Text('最近删除', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
        // 蜜罐图标
        Positioned(
          top: 69,
          left: 349,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HoneyPage(),
                ),
              );
            },
            child: SizedBox(
              width: 55,
              height: 56,
              child: Image.asset('assets/images/honey.png'),
            ),
          ),
        ),
        // 新建卡片按钮
        Positioned(
          top: 326,
          left: 354,
          child: GestureDetector(
            onTap: _showCardDialog,
            child: Image.asset('assets/images/plus_icon.png',
                width: 32, height: 32),
          ),
        ),
        // 显示新建的卡片
        ..._cards,
      ],
    );
  }
}
