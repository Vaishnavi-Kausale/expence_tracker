import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _showDialog()
  {
    if(Platform.isIOS) {
    showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Invalid input'),
                content: const Text(
                    'Please make sure valid title, amount, date and category was entered'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text('Okay'),
                  ),
                ],
      )); 
      } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Please make sure valid title, amount, date and category was entered'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text('Okay'),
                  ),
                ],
              ));
      }
  }

  void _submitExpenseDate() {
    final enteredamount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredamount == null || enteredamount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      //show error message
      _showDialog();
      return;
    }
    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredamount,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }

  // var _enteredTitle = '';

  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;

  // }
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    // showDatePicker(context: context, firstDate: firstDate, lastDate: now).then((value) {
    //   print(value);
    // });
    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
    print('Dated picked now: $_selectedDate');
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final titleTextFieldWidget = TextField(
        controller: _titleController,
        maxLength: 50,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          label: Text('Title'),
        ));
    final amountTextFieldWidget = TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        prefixText: '₹',
        label: Text('Amount'),
      ),
    );
    final datePickerExpanded = Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(_selectedDate == null
              ? 'No date selected'
              : formatter.format(_selectedDate!)),
          IconButton(
            onPressed: _presentDatePicker,
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
    );
    final categoryDropdownWidget = DropdownButton(
        value: _selectedCategory,
        items: Category.values
            .map(
              (category) => DropdownMenuItem(
                value: category,
                child: Text(
                  category.name.toUpperCase(),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          setState(() {
            _selectedCategory = value;
          });
        });
    final cancelButtonwidget = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancel'),
    );
    final saveButtonWidget = ElevatedButton(
      onPressed: _submitExpenseDate,
      child: const Text('Save Expense'),
    );

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: titleTextFieldWidget,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: amountTextFieldWidget,
                      ),
                    ],
                  )
                else
                  titleTextFieldWidget,
                if (width >= 600)
                  Row(
                    children: [
                      categoryDropdownWidget,
                      SizedBox(
                        width: 24,
                      ),
                      datePickerExpanded,
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: amountTextFieldWidget,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      datePickerExpanded
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      cancelButtonwidget,
                      saveButtonWidget,
                    ],
                  )
                else
                  Row(
                    children: [
                      categoryDropdownWidget,
                      const Spacer(),
                      cancelButtonwidget,
                      saveButtonWidget,
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
