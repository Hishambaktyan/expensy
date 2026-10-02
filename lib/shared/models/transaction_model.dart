class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final bool isExpense;
  final String category; 
  final String? note;
  final DateTime date;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.isExpense,
    required this.category,
    this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'amount': amount,
    'is_expense': isExpense ? 1 : 0,
    'category': category,
    'note': note,
    'date': date.millisecondsSinceEpoch,
  };

  factory TransactionModel.fromMap(Map<String, dynamic> m) => TransactionModel(
    id: m['id'] as int,
    title: m['title'] as String,
    amount: (m['amount'] as num).toDouble(),
    isExpense: m['is_expense'] == 1,
    category: m['category'] as String,
    note: m['note'] as String?,
    date: DateTime.fromMillisecondsSinceEpoch(m['date'] as int),
  );
}