import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseService _service = ExpenseService();

  List<Expense> _allExpenses = [];
  List<Expense> get allExpenses => _allExpenses;

  String selectedCategory = 'All';
  DateTime selectedMonth = DateTime.now();
  String searchQuery = '';
  DateTime? filterStartDate;
  DateTime? filterEndDate;

  final List<String> categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Other',
  ];

  bool isLoading = true;
  String? errorMessage;

  ExpenseProvider() {
    _listenToExpenses();
  }

  void _listenToExpenses() {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    _service.getExpenses().listen((data) {
      _allExpenses = data;
      isLoading = false;
      errorMessage = null;
      notifyListeners();
    }, onError: (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    });
  }

  void retry() {
    _listenToExpenses();
  }

  List<Expense> get filteredExpenses {
    return _allExpenses.where((e) {
      final matchesMonth = e.date.year == selectedMonth.year &&
          e.date.month == selectedMonth.month;
      final matchesCategory =
          selectedCategory == 'All' || e.category == selectedCategory;
      final matchesSearch = searchQuery.isEmpty ||
          e.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesDateRange = filterStartDate == null ||
          filterEndDate == null ||
          (e.date.isAfter(filterStartDate!.subtract(const Duration(days: 1))) &&
              e.date.isBefore(filterEndDate!.add(const Duration(days: 1))));
      return matchesMonth &&
          matchesCategory &&
          matchesSearch &&
          matchesDateRange;
    }).toList();
  }

  double get monthlyTotal {
    return filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setMonth(DateTime month) {
    selectedMonth = month;
    notifyListeners();
  }

  void setSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    filterStartDate = start;
    filterEndDate = end;
    notifyListeners();
  }

  void clearDateRange() {
    filterStartDate = null;
    filterEndDate = null;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) => _service.addExpense(expense);
  Future<void> updateExpense(Expense expense) =>
      _service.updateExpense(expense);
  Future<void> deleteExpense(String id) => _service.deleteExpense(id);
}