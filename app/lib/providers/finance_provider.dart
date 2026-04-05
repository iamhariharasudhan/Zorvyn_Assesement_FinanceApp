import 'package:flutter/material.dart';
import 'package:app/models/transaction.dart';
import 'package:app/models/goal.dart';
import 'package:app/services/storage_service.dart';
import 'dart:math';

class FinanceProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Transaction> _transactions = [];
  List<Goal> _goals = [];
  bool _isLoading = false;

  // Getters
  List<Transaction> get transactions => _transactions;
  List<Goal> get goals => _goals;
  bool get isLoading => _isLoading;

  // Summary calculations
  double get totalBalance {
    double balance = 0;
    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.income) {
        balance += transaction.amount;
      } else {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get savingsProgress {
    final activeGoals = _goals.where((g) => g.isActive).toList();
    if (activeGoals.isEmpty) return 0;

    final totalProgress =
        activeGoals.fold(0.0, (sum, g) => sum + g.progressPercentage);
    return totalProgress / activeGoals.length;
  }

  Map<TransactionCategory, double> get expensesByCategory {
    Map<TransactionCategory, double> categoryMap = {};
    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.expense) {
        categoryMap[transaction.category] =
            (categoryMap[transaction.category] ?? 0) + transaction.amount;
      }
    }
    return categoryMap;
  }

  // Get transactions for current month
  List<Transaction> get currentMonthTransactions {
    final now = DateTime.now();
    return _transactions
        .where((t) => t.date.year == now.year && t.date.month == now.month)
        .toList();
  }

  // Get transactions for current week
  List<Transaction> get currentWeekTransactions {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _transactions
        .where((t) =>
            t.date.isAfter(weekStart) &&
            t.date.isBefore(now.add(Duration(days: 1))))
        .toList();
  }

  // Get top spending category
  TransactionCategory? get topSpendingCategory {
    if (expensesByCategory.isEmpty) return null;
    var topCategory = expensesByCategory.entries.first;
    for (var entry in expensesByCategory.entries) {
      if (entry.value > topCategory.value) {
        topCategory = entry;
      }
    }
    return topCategory.key;
  }

  // Initialization
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _storageService.init();
      _transactions = await _storageService.loadTransactions();
      _goals = await _storageService.loadGoals();

      // Real-time: No sample data, users add their own transactions
    } catch (e) {
      print('Error initializing finance provider: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Transaction Methods
  Future<void> addTransaction(Transaction transaction) async {
    _transactions.add(transaction);
    notifyListeners();
    await _storageService.saveTransactions(_transactions);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      notifyListeners();
      await _storageService.saveTransactions(_transactions);
    }
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
    await _storageService.saveTransactions(_transactions);
  }

  List<Transaction> searchTransactions(String query) {
    return _transactions
        .where((t) =>
            t.description.toLowerCase().contains(query.toLowerCase()) ||
            (t.notes?.toLowerCase().contains(query.toLowerCase()) ?? false))
        .toList();
  }

  List<Transaction> filterByCategory(TransactionCategory category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  // Goal Methods
  Future<void> addGoal(Goal goal) async {
    _goals.add(goal);
    notifyListeners();
    await _storageService.saveGoals(_goals);
  }

  Future<void> updateGoal(Goal goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      notifyListeners();
      await _storageService.saveGoals(_goals);
    }
  }

  Future<void> deleteGoal(String id) async {
    _goals.removeWhere((g) => g.id == id);
    notifyListeners();
    await _storageService.saveGoals(_goals);
  }

  Future<void> updateGoalProgress(String goalId, double amount) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _goals[index];
      final newAmount = min(goal.currentAmount + amount, goal.targetAmount);
      _goals[index] = goal.copyWith(currentAmount: newAmount);
      notifyListeners();
      await _storageService.saveGoals(_goals);
    }
  }

  // Cleanup all data
  Future<void> clearAllData() async {
    _transactions.clear();
    _goals.clear();
    notifyListeners();
    await _storageService.clearAllData();
  }
}
