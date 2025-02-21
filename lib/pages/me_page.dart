import 'mood_report_page.dart';
import 'package:flutter/material.dart';
import 'settings_page.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          Positioned(
            top: 60,
            left: 34,
            child: Image.asset('assets/images/goodafternoon.png'),
          ),
          Positioned(
            top: 221,
            left: 42,
            child: Container(
              width: 333,
              height: 252,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '进行今日心情打卡\n即可解锁今日心情卡片推荐',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          Positioned(
            top: 706,
            left: 46,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MoodReportPage(),
                  ),
                );
              },
              child: Container(
                width: 174,
                height: 79,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    '心情周报',
                    style: TextStyle(
                      //  fontFamily: 'Yrsa',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.green, // 设置文字颜色为绿色
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 706,
            left: 249,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
              child: Container(
                width: 116,
                height: 79,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    '设置',
                    style: TextStyle(
                      //  fontFamily: 'Yrsa',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.green, // 设置文字颜色为绿色
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
