import 'package:flutter/material.dart';
import '../services/finnhub_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' show min, max;
import '../services/firestore_service.dart';

class StockDetailScreen extends StatefulWidget {
  final String symbol;
  final String name;

  const StockDetailScreen({
    Key? key,
    required this.symbol,
    required this.name,
  }) : super(key: key);

  @override
  _StockDetailScreenState createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  //stock details
  Map<String, dynamic> stockDetails = {};
  //company profile
  Map<String, dynamic> companyProfile = {};
  //basic financials
  Map<String, dynamic> basicFinancials = {};
  //chart data
  List<FlSpot> chartData = [];
  //loading state
  bool isLoading = true;
  //watchlist state
  bool isInWatchlist = false;

    
  @override
  void initState() {
    super.initState();
    _loadData();
    _checkWatchlistStatus();
  }
  //get data from finnhub
  Future<void> _loadData() async {
    try {
      //get stock details
      final details = await FinnhubService.getStockDetails(widget.symbol);
      final profile = await FinnhubService.getCompanyProfile(widget.symbol);
      final financials = await FinnhubService.getBasicFinancials(widget.symbol);
      
      setState(() {
        //set stock details
        stockDetails = details;
        companyProfile = profile;
        basicFinancials = financials;
        
        if (details.isNotEmpty) {
          //create chart data points 
          double open = details['o'] ?? 0;    
          double low = details['l'] ?? 0; 
          double high = details['h'] ?? 0;
          double current = details['c'] ?? 0; 
          
          chartData = [
            FlSpot(0, open),
            FlSpot(1, low), 
            FlSpot(2, high),
            FlSpot(3, current), 
          ];
        }
        
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkWatchlistStatus() async {
    final status = await FirestoreService.isInWatchlist(widget.symbol);
    setState(() {
      isInWatchlist = status;
    });
  }

  Future<void> _toggleWatchlist() async {
    try {
      if (isInWatchlist) {
        await FirestoreService.removeFromWatchlist(widget.symbol);
      } else {
        await FirestoreService.addToWatchlist(widget.symbol, widget.name);
      }
      setState(() {
        isInWatchlist = !isInWatchlist;
      });
    } catch (e) {
      print('Error toggling watchlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symbol),
        backgroundColor: Colors.blue[100],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildPriceSection(),
                  _buildChart(),
                  _buildCompanyInfo(),
                  _buildFinancialMetrics(),
                ],
              ),
            ),
    );
  }

  //build header
  Widget _buildHeader() {
    double priceChange = (stockDetails['c'] ?? 0.0) - (stockDetails['pc'] ?? 0.0);
    double percentageChange = (priceChange / (stockDetails['pc'] ?? 1)) * 100;
    Color changeColor = priceChange >= 0 ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$${stockDetails['c']?.toStringAsFixed(2) ?? 'N/A'}',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${priceChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: changeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _toggleWatchlist,
            icon: Icon(
              isInWatchlist ? Icons.star : Icons.star_border,
              color: isInWatchlist ? Colors.amber : Colors.white,
            ),
            label: Text(
              isInWatchlist ? 'Remove from Watchlist' : 'Add to Watchlist',
              style: const TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isInWatchlist ? Colors.grey[200] : Colors.blue,
              foregroundColor: isInWatchlist ? Colors.black87 : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
// price section
  Widget _buildPriceSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPriceInfo('Open', stockDetails['o']),
          _buildPriceInfo('High', stockDetails['h']),
          _buildPriceInfo('Low', stockDetails['l']),
          _buildPriceInfo('Prev Close', stockDetails['pc']),
        ],
      ),
    );
  }
// price info
  Widget _buildPriceInfo(String label, dynamic value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${value?.toStringAsFixed(2) ?? 'N/A'}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
// chart
  Widget _buildChart() {
    if (chartData.isEmpty) {
      return const Center(child: Text('No chart data available'));
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                //axis titles
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Open');
                    case 1:
                      return const Text('Low');
                    case 2:
                      return const Text('High');
                    case 3:
                      return const Text('Current');
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          //min max values for chart
          minX: 0,
          maxX: 3,
          minY: chartData.map((spot) => spot.y).reduce(min) * 0.999,
          maxY: chartData.map((spot) => spot.y).reduce(max) * 1.001,
          lineBarsData: [
            LineChartBarData(
            //trend line
              spots: chartData,
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //company info
  Widget _buildCompanyInfo() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company Info',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCompanyDetail('Industry', companyProfile['finnhubIndustry']),
            _buildCompanyDetail('Country', companyProfile['country']),
            _buildCompanyDetail('Market Cap', 
              '\$${_formatMarketCap(companyProfile['marketCapitalization'] ?? 0)}'),
            if (companyProfile['weburl'] != null)
              _buildCompanyDetail('Website', companyProfile['weburl']),
          ],
        ),
      ),
    );
  }

  //format market cap
  String _formatMarketCap(num marketCap) {
    //convert from millions to billions
    double marketCapInBillions = marketCap / 1000;
    //format based on value
    if (marketCapInBillions >= 1000) {
      return '${(marketCapInBillions / 1000).toStringAsFixed(2)}T';
    } else if (marketCapInBillions >= 1) {
      return '${marketCapInBillions.toStringAsFixed(2)}B';
    } else {
      return '${(marketCapInBillions * 1000).toStringAsFixed(2)}M';
    }
  }

  //company detail
  Widget _buildCompanyDetail(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  //financial metrics
  Widget _buildFinancialMetrics() {
    final metrics = basicFinancials['metric'] ?? {};
    final series = basicFinancials['series']?['annual'] ?? {};

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Key Metrics
            _buildMetricRow('Beta', metrics['beta']?.toStringAsFixed(2)),
            _buildMetricRow('52 Week High', '\$${metrics['52WeekHigh']?.toStringAsFixed(2)}'),
            _buildMetricRow('52 Week Low', '\$${metrics['52WeekLow']?.toStringAsFixed(2)}'),
            _buildMetricRow('10D Avg Volume', _formatVolume(metrics['10DayAverageTradingVolume'])),
            
            const Divider(height: 32),
            
            // Latest Annual Metrics
            if (series['currentRatio']?.isNotEmpty ?? false)
              _buildMetricRow('Current Ratio', 
                series['currentRatio'][0]['v']?.toStringAsFixed(2)),
            
            if (series['salesPerShare']?.isNotEmpty ?? false)
              _buildMetricRow('Sales Per Share', 
                '\$${series['salesPerShare'][0]['v']?.toStringAsFixed(2)}'),
            
            if (series['netMargin']?.isNotEmpty ?? false)
              _buildMetricRow('Net Margin', 
                '${(series['netMargin'][0]['v'] * 100).toStringAsFixed(2)}%'),
          ],
        ),
      ),
    );
  }

  //format volume
  String _formatVolume(dynamic volume) {  
    if (volume == null) return 'N/A';
    if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(2)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(2)}K';
    }
    return volume.toStringAsFixed(2);
  }

  //metric row
  Widget _buildMetricRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value ?? 'N/A',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
