import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/models/transaction.dart';
import 'package:app/models/goal.dart';

class StorageService {
  static const String _transactionsKey = 'transactions';
  static const String _goalsKey = 'goals';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Transaction Methods
  Future<List<Transaction>> loadTransactions() async {
    try {
      final jsonString = _prefs.getString(_transactionsKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonData = json.decode(jsonString) as List;

      return jsonData
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading transactions: $e');
      return [];
    }
  }

  Future<void> saveTransactions(List<Transaction> transactions) async {
    try {
      final jsonData = transactions.map((t) => t.toJson()).toList();
      await _prefs.setString(_transactionsKey, json.encode(jsonData));
    } catch (e) {
      print('Error saving transactions: $e');
      rethrow;
    }
  }

  // Goal Methods
  Future<List<Goal>> loadGoals() async {
    try {
      final jsonString = _prefs.getString(_goalsKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonData = json.decode(jsonString) as List;

      return jsonData
          .map((e) => Goal.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading goals: $e');
      return [];
    }
  }

  Future<void> saveGoals(List<Goal> goals) async {
    try {
      final jsonData = goals.map((g) => g.toJson()).toList();
      await _prefs.setString(_goalsKey, json.encode(jsonData));
    } catch (e) {
      print('Error saving goals: $e');
      rethrow;
    }
  }

  // Cleanup
  Future<void> clearAllData() async {
    try {
      await _prefs.remove(_transactionsKey);
      await _prefs.remove(_goalsKey);
    } catch (e) {
      print('Error clearing data: $e');
      rethrow;
    }
  }
}
