import 'package:flutter/material.dart';

class MoodReportPage extends StatelessWidget {
  const MoodReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('心情周报'),
      ),
      body: const Center(
        child: Text('这是心情周报页面。'),
      ),
    );
  }
}
