import 'package:flutter/material.dart';
import 'setting.dart';
import 'newfeed_screen.dart';
import '../services/finnhub_service.dart';
import '../services/firestore_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'stock_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //current tab index
  int _currentIndex = 0;

//tab screens
  final List<Widget> _screens = [
    const HomeTab(),
    const StocksTab(), 
    const NewsTab(), 
    const SettingsScreen(), 
  ];

 //update page index
  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //display selected screen
      body: _screens[_currentIndex],
      //bottom navigation bar
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

//home
class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  void _navigateToStocksTab(BuildContext context) {
    //update current index
    final homeScreen = context.findAncestorStateOfType<_HomeScreenState>();
    if (homeScreen != null) {
      homeScreen._onTabSelected(1); // 1 is the index of the Stocks tab
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Tracker App'),
        backgroundColor: Colors.blue[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //watchlist preview
                const Text(
                  'Watchlist',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //navigate to stocks tab
                TextButton(
                  onPressed: () => _navigateToStocksTab(context),
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            //watchlist display
            StreamBuilder<QuerySnapshot>(
              stream: FirestoreService.getWatchlist(),
              builder: (context, snapshot) {
                //error handling
                if (snapshot.hasError) {
                  return const Text('Error loading watchlist');
                }

                //loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final watchlist = snapshot.data?.docs ?? [];

                //empty watchlist
                if (watchlist.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_border, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            'No stocks in watchlist',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _navigateToStocksTab(context),
                            child: const Text('Add Stocks'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                //show first 5 stocks
                final topStocks = watchlist.take(5).toList();

                //display stocks
                return Column(
                  children: [
                    for (var stock in topStocks)
                      _buildWatchlistItem(stock.data() as Map<String, dynamic>, context),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //display stock tile
  Widget _buildWatchlistItem(Map<String, dynamic> stock, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: FutureBuilder<Map<String, dynamic>>(
        future: FinnhubService.getStockDetails(stock['symbol']),
        builder: (context, snapshot) {
          //get stock details
          final stockDetails = snapshot.data ?? {};
          final currentPrice = stockDetails['c']?.toStringAsFixed(2);
          final priceChange = (stockDetails['c'] ?? 0.0) - (stockDetails['pc'] ?? 0.0);
          final changePercent = ((priceChange / (stockDetails['pc'] ?? 1)) * 100).toStringAsFixed(2); //change percentage
          final isPositive = priceChange >= 0;

          //display stock tile
          return ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: Text(stock['symbol']),
            subtitle: Text(stock['name']),
            trailing: snapshot.hasData ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '\$$currentPrice',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${isPositive ? '+' : ''}$changePercent%',
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ) : const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            onTap: () {
              //navigate to stock detail screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StockDetailScreen(
                    symbol: stock['symbol'],
                    name: stock['name'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

//stocks tab
class StocksTab extends StatefulWidget {
  const StocksTab({Key? key}) : super(key: key);

  @override
  _StocksTabState createState() => _StocksTabState();
}

class _StocksTabState extends State<StocksTab> {
  //search controller
  final TextEditingController _searchController = TextEditingController();
  //search results
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  bool isSearching = false;

  //handle search
  void _onSearchChanged(String query) async {
    setState(() {
      isLoading = true;
      isSearching = query.isNotEmpty;
    });

    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isLoading = false;
        isSearching = false;
      });
      return;
    }

    //search stocks using Finnhub API
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
          //search Bar
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
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              ),
            ),
          ),

          //search results or watchlist
          Expanded(
            child: isLoading 
              ? const Center(child: CircularProgressIndicator())
              : isSearching 
                ? _buildSearchResults()
                : _buildWatchlist(),
          ),
        ],
      ),
    );
  }

  //display search results
  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final stock = searchResults[index];
        return ListTile(
          title: Text(stock['description'] ?? ''),
          subtitle: Text(stock['symbol'] ?? ''),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
    );
  }

  //display watchlist
  Widget _buildWatchlist() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreService.getWatchlist(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final watchlist = snapshot.data?.docs ?? [];

        if (watchlist.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Your watchlist is empty\nSearch above to add stocks',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Watchlist',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: watchlist.length,
                itemBuilder: (context, index) {
                  final stock = watchlist[index].data() as Map<String, dynamic>;
                  //get stock details
                  return FutureBuilder<Map<String, dynamic>>(
                    future: FinnhubService.getStockDetails(stock['symbol']),
                    builder: (context, snapshot) {
                      final stockDetails = snapshot.data ?? {};
                      final currentPrice = stockDetails['c']?.toStringAsFixed(2);
                      final priceChange = (stockDetails['c'] ?? 0.0) - (stockDetails['pc'] ?? 0.0);
                      final changePercent = ((priceChange / (stockDetails['pc'] ?? 1)) * 100).toStringAsFixed(2);
                      final isPositive = priceChange >= 0;

                      //display stock tile
                      return ListTile(
                        leading: const Icon(Icons.star, color: Colors.amber),
                        title: Text(stock['symbol']),
                        subtitle: Text(stock['name']),
                        trailing: snapshot.hasData ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //display stock price
                            Text(
                              '\$$currentPrice',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            //display stock change percentage
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isPositive ? Colors.green[50] : Colors.red[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${isPositive ? '+' : ''}$changePercent%',
                                style: TextStyle(
                                  color: isPositive ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ) : const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        onTap: () {
                          //navigate to stock detail screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StockDetailScreen(
                                symbol: stock['symbol'],
                                name: stock['name'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class NewsTab extends StatelessWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewsFeedScreen();
  }
}

//settings tab
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
            //todo: add account settings
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          onTap: () {
            //todo: add notification settings
          },
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy'),
          onTap: () {
            //todo: add privacy settings
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
