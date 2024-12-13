import 'package:http/http.dart' as http;
import 'dart:convert';

class FinnhubService {
    //api key
  static const String apiKey = 'csun8k1r01qgo8ni898gcsun8k1r01qgo8ni8990';
  static const String baseUrl = 'https://finnhub.io/api/v1';

  static String _normalizeSymbol(String symbol) {
    //remove exchange suffixes (ex: aapl.us)
    return symbol.split('.')[0].toUpperCase();
  }

 //search stocks
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

  //get stock details
  static Future<Map<String, dynamic>> getStockDetails(String symbol) async {
    final normalizedSymbol = _normalizeSymbol(symbol);
    final url = Uri.parse('$baseUrl/quote?symbol=$normalizedSymbol&token=$apiKey');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      }
      throw Exception('Failed to get stock details');
    } catch (e) {
      print('Error getting stock details: $e');
      return {};
    }
  }

  //get company profile
  static Future<Map<String, dynamic>> getCompanyProfile(String symbol) async {
    final normalizedSymbol = _normalizeSymbol(symbol);
    final url = Uri.parse('$baseUrl/stock/profile2?symbol=$normalizedSymbol&token=$apiKey');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      }
      throw Exception('Failed to get company profile');
    } catch (e) {
      print('Error getting company profile: $e');
      return {};
    }
  }

  //get basic financials
  static Future<Map<String, dynamic>> getBasicFinancials(String symbol) async {
    final normalizedSymbol = _normalizeSymbol(symbol);
    final url = Uri.parse('$baseUrl/stock/metric?symbol=$normalizedSymbol&metric=all&token=$apiKey');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      }
      throw Exception('Failed to get basic financials');
    } catch (e) {
      print('Error getting basic financials: $e');
      return {};
    }
  }
}