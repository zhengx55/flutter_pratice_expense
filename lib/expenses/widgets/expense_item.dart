import 'package:flutter/material.dart';
import 'package:flutter_application_dice/expenses/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense});
  final Expense expense;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                Row(
                  children: [
                    Text(categoryIcons[expense.category]!),
                    const SizedBox(width: 8),
                    Text(expense.formattedDate)
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
