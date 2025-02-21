import 'package:flutter/material.dart';

class SoulTreePage extends StatelessWidget {
  const SoulTreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SoulTree'),
      ),
      body: const Center(
        child: Text('This is the SoulTree page.'),
      ),
    );
  }
}
