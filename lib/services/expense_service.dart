import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('expenses');

  Stream<List<Expense>> getExpenses() {
    return _collection.orderBy('date', descending: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) =>
                Expense.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addExpense(Expense expense) {
    return _collection.add(expense.toMap());
  }

  Future<void> updateExpense(Expense expense) {
    return _collection.doc(expense.id).update(expense.toMap());
  }

  Future<void> deleteExpense(String id) {
    return _collection.doc(id).delete();
  }
}