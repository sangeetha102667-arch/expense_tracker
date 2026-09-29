import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/theme_provider.dart';
import '../models/expense.dart';
import 'add_edit_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final currency = NumberFormat.currency(symbol: 'Rs. ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(themeProvider.themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode),
                onPressed: themeProvider.toggleTheme,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMonthSelector(context, provider),
          _buildTotalCard(provider, currency),
          _buildFilters(context, provider),
          Expanded(child: _buildExpenseList(context, provider, currency)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AddEditExpenseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context, ExpenseProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              final prev = DateTime(provider.selectedMonth.year,
                  provider.selectedMonth.month - 1);
              provider.setMonth(prev);
            },
          ),
          Text(
            DateFormat('MMMM yyyy').format(provider.selectedMonth),
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final next = DateTime(provider.selectedMonth.year,
                  provider.selectedMonth.month + 1);
              provider.setMonth(next);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(ExpenseProvider provider, NumberFormat currency) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Total this month',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text(
              currency.format(provider.monthlyTotal),
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, ExpenseProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search expenses...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: provider.setSearch,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['All', ...provider.categories].map((cat) {
                final selected = provider.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) => provider.setCategory(cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.date_range, size: 18),
                  label: Text(
                    provider.filterStartDate == null
                        ? 'Filter by date'
                        : '${DateFormat('dd/MM').format(provider.filterStartDate!)} - ${DateFormat('dd/MM').format(provider.filterEndDate!)}',
                  ),
                  onPressed: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (range != null) {
                      provider.setDateRange(range.start, range.end);
                    }
                  },
                ),
              ),
              if (provider.filterStartDate != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: provider.clearDateRange,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseList(
      BuildContext context, ExpenseProvider provider, NumberFormat currency) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text('Something went wrong.\n${provider.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: provider.retry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    final expenses = provider.filteredExpenses;
    if (expenses.isEmpty) {
      return const Center(
        child: Text('No expenses found.\nTap + to add one.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Dismissible(
          key: Key(expense.id!),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete expense?'),
                content: Text('Delete "${expense.title}"?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete')),
                ],
              ),
            );
          },
          onDismissed: (_) => provider.deleteExpense(expense.id!),
          child: ListTile(
            title: Text(expense.title),
            subtitle: Text(
                '${expense.category} • ${DateFormat('dd MMM yyyy').format(expense.date)}'),
            trailing: Text(
              currency.format(expense.amount),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        AddEditExpenseScreen(expense: expense)),
              );
            },
          ),
        );
      },
    );
  }
}      