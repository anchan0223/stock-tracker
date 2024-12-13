import 'package:flutter/material.dart';
import 'setting.dart';
import 'newfeed_screen.dart';
import '../services/finnhub_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'stock_detail_screen.dart';

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
    const NewsTab(), // News Screen (updated to use NewsFeedScreen)
    const SettingsScreen(), // Updated Settings Page
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

      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
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

// Dummy screens for each tab (Home, Stocks, News)
class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Tracker App'),
        backgroundColor: Colors.blue[100],
      ),
      body: const Center(
        child: Text('Home Screen Content'),
      ),
    );
  }
}

class StocksTab extends StatefulWidget {
  const StocksTab({Key? key}) : super(key: key);

  @override
  _StocksTabState createState() => _StocksTabState();
}

class _StocksTabState extends State<StocksTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  void _onSearchChanged(String query) async {
    setState(() {
      isLoading = true;
    });

    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      return;
    }

    try {
      final results = await FinnhubService.searchStocks(query);
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      print('Error searching stocks: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Stocks'),
        backgroundColor: Colors.blue[100],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search stocks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final stock = searchResults[index];
                      return ListTile(
                        title: Text(stock['description'] ?? ''),
                        subtitle: Text(stock['symbol'] ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StockDetailScreen(
                                symbol: stock['symbol'] ?? '',
                                name: stock['description'] ?? '',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class NewsTab extends StatelessWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewsFeedScreen();
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _logOut(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue[100],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const SizedBox(height: 20),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Account'),
          onTap: () {
            // Navigate to Account settings or perform action
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          onTap: () {
            // Navigate to Notification settings or perform action
          },
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy'),
          onTap: () {
            // Navigate to Privacy settings or perform action
          },
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: () => _logOut(context),
          icon: const Icon(Icons.logout),
          label: const Text('Log Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
