import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final formatter = DateFormat.yMd();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: '🍔',
  Category.travel: '✈️',
  Category.leisure: '🎉',
  Category.work: '💼',
};

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();
  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
