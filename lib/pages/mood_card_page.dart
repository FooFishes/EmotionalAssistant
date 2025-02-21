import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MoodCardPage extends StatefulWidget {
  final void Function(String, String) onMoodAdded;
  final String? initialMood;
  final String? initialImagePath;

  const MoodCardPage({
    Key? key,
    required this.onMoodAdded,
    this.initialMood,
    this.initialImagePath,
  }) : super(key: key);

  @override
  _MoodCardPageState createState() => _MoodCardPageState();
}

class _MoodCardPageState extends State<MoodCardPage> {
  late TextEditingController _textController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialMood);
    _imagePath = widget.initialImagePath;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveMood() {
    if (_textController.text.isNotEmpty) {
      widget.onMoodAdded(_textController.text, _imagePath ?? '');
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入你想说的话')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('心情卡片'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: '请输入你想说的话',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('拍照'),
                            onTap: () {
                              Navigator.pop(context);
                              _takePhoto();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text('从相册选择'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imagePath != null
                    ? Image.file(
                        File(_imagePath!),
                        fit: BoxFit.cover,
                      )
                    : const Center(child: Text('点击添加图片')),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMood,
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
