import 'package:http/http.dart' as http;
import 'dart:convert';

class FinnhubService {
  static const String apiKey = 'ctd7ua9r01qlc0v08s80ctd7ua9r01qlc0v08s8g';
  static const String baseUrl = 'https://finnhub.io/api/v1';

  // Search stocks
  static Future<List<Map<String, dynamic>>> searchStocks(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse('$baseUrl/search?q=$query&token=$apiKey');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['result']);
      }
      throw Exception('Failed to search stocks');
    } catch (e) {
      print('Error searching stocks: $e');
      return [];
    }
  }

  // Get stock details
  static Future<Map<String, dynamic>> getStockDetails(String symbol) async {
    final url = Uri.parse('$baseUrl/quote?symbol=$symbol&token=$apiKey');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to get stock details');
    } catch (e) {
      print('Error getting stock details: $e');
      return {};
    }
  }
}