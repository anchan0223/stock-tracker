import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String watchlistCollection = 'watchlists';

  static String? get currentUserId => _auth.currentUser?.uid;

  static Future<void> addToWatchlist(String symbol, String name) async {
    if (currentUserId == null) throw Exception('User not logged in');
    
    try {
      await _db
          .collection(watchlistCollection)
          .doc(currentUserId)
          .collection('stocks')
          .doc(symbol)
          .set({
        'symbol': symbol,
        'name': name,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error adding to watchlist: $e');
      rethrow;
    }
  }

  static Future<void> removeFromWatchlist(String symbol) async {
    if (currentUserId == null) throw Exception('User not logged in');
    
    try {
      await _db
          .collection(watchlistCollection)
          .doc(currentUserId)
          .collection('stocks')
          .doc(symbol)
          .delete();
    } catch (e) {
      debugPrint('Error removing from watchlist: $e');
      rethrow;
    }
  }

  static Future<bool> isInWatchlist(String symbol) async {
    if (currentUserId == null) return false;
    
    try {
      final doc = await _db
          .collection(watchlistCollection)
          .doc(currentUserId)
          .collection('stocks')
          .doc(symbol)
          .get();
      return doc.exists;
    } catch (e) {
      debugPrint('Error checking watchlist status: $e');
      return false;
    }
  }

  static Stream<QuerySnapshot> getWatchlist() {
    if (currentUserId == null) {
      return Stream.value(null as QuerySnapshot); // Empty stream if not logged in
    }
    
    try {
      return _db
          .collection(watchlistCollection)
          .doc(currentUserId)
          .collection('stocks')
          .orderBy('addedAt', descending: true)
          .snapshots();
    } catch (e) {
      debugPrint('Error getting watchlist stream: $e');
      rethrow;
    }
  }
} 