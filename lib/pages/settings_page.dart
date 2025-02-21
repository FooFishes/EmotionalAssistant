import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showUserAgreement(BuildContext context) {
    // 用户协议页面的逻辑
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('用户协议'),
          content: const Text('这里是用户协议的内容...'),
          actions: <Widget>[
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

  void _showPrivacyPolicy(BuildContext context) {
    // 隐私政策页面的逻辑
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('隐私政策'),
          content: const Text('这里是隐私政策的内容...'),
          actions: <Widget>[
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        elevation: 0, // 去除阴影效果
        backgroundColor: Colors.transparent, // 设置背景透明
      ),
      backgroundColor: const Color.fromRGBO(241, 254, 229, 1), // 设置整个页面背景为浅绿色
      body: Padding(
        padding: const EdgeInsets.only(top: 53, left: 37),
        child: Container(
          width: 338,
          height: 450,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(227, 241, 213, 1), // 灰绿色边框
            borderRadius: BorderRadius.circular(21), // 圆角
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 23),
              const Text(
                '   关于我们',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '     我们团队洞察市场与用户需求，打造了一款独特的\n     App。它创新性地融合情绪记录、创意表达和心理疗\n     愈功能，为用户构建综合性心理健康管理平台。用户\n     可在此记录情绪、借创意表达释放压力，获得全方位\n     心理疗愈。',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              const Text(
                '   Version 1.0.0',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 8),
              const Text(
                '     更多功能将陆续上线！敬请期待',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              const Text(
                '   联系我们',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '     请联系官方客服：\n     可以提出您的建议与问题，我们将尽快解决',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _showUserAgreement(context),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        ' 用户协议',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.black),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _showPrivacyPolicy(context),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        ' 隐私政策',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
