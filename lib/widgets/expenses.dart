import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpenseState();
  }
}

class _ExpenseState extends State<Expenses> {
  final List<Expense> _registeredExpense = [
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Movie',
        amount: 69.99,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpense.indexOf(expense);

    setState(() {
      _registeredExpense.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3,),
        content: const Text('Expense deleted'),
        action: SnackBarAction(label: 'Undo', onPressed: () {
          setState(() {
            _registeredExpense.insert(expenseIndex, expense);
          });
        })
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpense(
            onAddExpense: _addExpense,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Text('No Expense found. Start adding some!'),
    );

    if (_registeredExpense.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: _registeredExpense,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Expense Tracker'),
        actions: [
          IconButton(onPressed: _openAddExpenseOverlay, icon: Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
          Text('Expense'),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
