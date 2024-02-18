import 'package:flutter/material.dart';
import 'package:flutter_application_dice/expenses/models/expense.dart';
import 'package:intl/intl.dart';

final formater = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Pleas make sure a valid title, amount, date and category are entered'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'),
                  ),
                ],
              ));
      return;
    }
    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 50,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10), // Add this line
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixText: '\$',
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null
                        ? "No date selected"
                        : formatter.format(_selectedDate!)),
                    IconButton(
                        onPressed: () {
                          _presentDatePicker();
                        },
                        icon: const Icon(Icons.calendar_month_outlined))
                  ],
                ))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.name.toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        if (value == null) {
                          return;
                        }
                        _selectedCategory = value;
                      });
                    }),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    _submitExpenseData();
                  },
                  child: const Text('Save Expense'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
