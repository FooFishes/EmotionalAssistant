import 'package:flutter/material.dart';
import 'pages/soul_tree_page.dart';
import 'pages/me_page.dart';
import 'pages/collections_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    const CollectionsPage(),
    const SoulTreePage(),
    const MePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 更新选中项索引
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icon1.png',
              width: 24,
              height: 24,
            ),
            label: 'Collections',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icon2.png',
              width: 24,
              height: 24,
            ),
            label: 'SoulTree',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icon3.png',
              width: 30,
              height: 28.97,
            ),
            label: 'Me',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
