import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current selected index for the Bottom Navigation
  int _currentIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = [
    const HomeTab(), // Home Screen
    const StocksTab(), // Stocks Screen
    const NewsTab(), // News Screen
    const SettingsTab(), // Settings Screen
  ];

  // Update the current index when a new tab is selected
  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search stocks'),
        backgroundColor: Colors.blue[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // You can add search functionality here
            },
          ),
        ],
      ),
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/home.png',
              width: 24,
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/stock.png',
              width: 24,
              height: 24,
            ),
            label: 'Stocks',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/news.png',
              width: 24,
              height: 24,
            ),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/setting.png',
              width: 24,
              height: 24,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Dummy screens for each tab (Home, Stocks, News, Settings)
class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Home Screen Content'),
        // Add more widgets as needed
      ],
    );
  }
}

class StocksTab extends StatelessWidget {
  const StocksTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Stocks Screen Content'),
        // Add stock-related widgets here
      ],
    );
  }
}

class NewsTab extends StatelessWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('News Screen Content'),
        // Add news-related widgets here
      ],
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Settings Screen Content'),
        // Add settings-related widgets here
      ],
    );
  }
}
