import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String? id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String note;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'note': note,
    };
  }

  factory Expense.fromMap(String id, Map<String, dynamic> map) {
    return Expense(
      id: id,
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      category: map['category'] ?? 'Other',
      date: (map['date'] as Timestamp).toDate(),
      note: map['note'] ?? '',
    );
  }
}
