import 'package:expense_tracker_app/shared/cubits/appCubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../modules/statistics_screen.dart';
import '../../localization/app_localizations.dart';
import '../../models/transaction_model.dart';
import '../../networks/local/cache_helper.dart';
import 'package:expense_tracker_app/modules/home_screen.dart';
import 'package:expense_tracker_app/modules/settings_screen.dart';
import 'package:expense_tracker_app/modules/transactions_screen.dart';

import '../../networks/local/db_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitThemeState()) ;

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    TransactionsScreen(),
    StatisticsScreen(),
    SettingsScreen()
  ];

  bool isDark = false;

  void changeIndex(int value) {
    currentIndex = value;
    emit(ChangeNavBarState());
  }

  void changeTheme({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
    } else {
      isDark = !isDark;
    }

    CacheHelper.saveData(key: 'isDark', value: isDark);

    emit(ChangeThemeState());
  }

  Locale currentLocale = const Locale('en');

  String get language => currentLocale.languageCode;

  void changeLanguage(String languageCode) {
    currentLocale = Locale(languageCode);

    CacheHelper.saveData(
      key: 'languageCode',
      value: languageCode,
    );

    emit(ChangeLanguageState());
  }

  void getSavedLanguage() {
    final languageCode = CacheHelper.getData(key: 'languageCode');

    if (languageCode != null) {
      currentLocale = Locale(languageCode);
    }
  }

  List<TransactionModel> transactions = [];

  Future<void> loadTransactions() async {
    transactions = await DbHelper.getAll();
    emit(TransactionsChangedState());
  }

  Future<void> addTransaction(TransactionModel t) async {
    await DbHelper.insert(t);
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await DbHelper.delete(id);
    await loadTransactions();
  }

  double get totalIncome => transactions.where((t) => !t.isExpense).fold(0.0, (s, t) => s + t.amount);
  double get totalExpense => transactions.where((t) => t.isExpense).fold(0.0, (s, t) => s + t.amount);
  double get balance => totalIncome - totalExpense;

  Map<String, double> get expenseByCategory {
    final map = <String, double>{};
    for (final t in transactions.where((t) => t.isExpense)) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }

  List<MapEntry<String, double>> get sortedExpenseCategories {
    final list = expenseByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return list;
  }

  String _normalize(String p) => p.toLowerCase().replaceAll(' ', '_');

  List<DateTime> _periodRange(String period) {
    final now = DateTime.now();
    switch (_normalize(period)) {
      case 'today':
        return [DateTime(now.year, now.month, now.day), DateTime(now.year, now.month, now.day + 1)];
      case 'this_week':
        final s = DateTime(now.year, now.month, now.day - (now.weekday - 1));
        return [s, DateTime(s.year, s.month, s.day + 7)];
      case 'this_month':
        return [DateTime(now.year, now.month), DateTime(now.year, now.month + 1)];
      default:
        return [DateTime(now.year), DateTime(now.year + 1)];
    }
  }

  List<TransactionModel> transactionsIn(String period) {
    final r = _periodRange(period);
    return transactions.where((t) => !t.date.isBefore(r[0]) && t.date.isBefore(r[1])).toList();
  }

  double incomeIn(String period) => transactionsIn(period).where((t) => !t.isExpense).fold(0.0, (s, t) => s + t.amount);

  double expenseIn(String period) => transactionsIn(period).where((t) => t.isExpense).fold(0.0, (s, t) => s + t.amount);

  List<MapEntry<String, double>> sortedExpenseCategoriesIn(String period) {
    final map = <String, double>{};
    for (final t in transactionsIn(period).where((t) => t.isExpense)) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  }

  String _monthShort(DateTime d) {
    try {
      return DateFormat('MMM', language).format(d);
    } catch (_) {
      return DateFormat('MMM').format(d);
    }
  }

  ChartData spendingChart(String period) {
    final p = _normalize(period);
    final now = DateTime.now();
    final expenses = transactionsIn(p).where((t) => t.isExpense);
    late List<double> values;
    late List<String> labels;

    switch (p) {
      case 'today':
        values = List.filled(6, 0.0);
        labels = ['0', '4', '8', '12', '16', '20'];
        for (final t in expenses) {
          values[t.date.hour ~/ 4] += t.amount;
        }
        break;
      case 'this_week':
        values = List.filled(7, 0.0);
        const keys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
        labels = keys.map((k) => AppLocalizations.translate(k, language)).toList();
        for (final t in expenses) {
          values[t.date.weekday - 1] += t.amount;
        }
        break;
      case 'this_month':
        final days = DateTime(now.year, now.month + 1, 0).day;
        final n = (days / 7).ceil();
        values = List.filled(n, 0.0);
        labels = List.generate(n, (i) => '${i * 7 + 1}');
        for (final t in expenses) {
          final i = (t.date.day - 1) ~/ 7;
          if (i < n) values[i] += t.amount;
        }
        break;
      default:
        values = List.filled(12, 0.0);
        labels = List.generate(12, (i) => _monthShort(DateTime(now.year, i + 1)));
        for (final t in expenses) {
          values[t.date.month - 1] += t.amount;
        }
    }
    return ChartData(values, labels);
  }

  List<MonthlyData> monthlyIncomeExpense({int months = 6}) {
    final now = DateTime.now();
    return List.generate(months, (i) {
      final m = DateTime(now.year, now.month - (months - 1 - i));
      final list = transactions.where((t) => t.date.year == m.year && t.date.month == m.month);
      return MonthlyData(
        _monthShort(m),
        list.where((t) => !t.isExpense).fold(0.0, (s, t) => s + t.amount),
        list.where((t) => t.isExpense).fold(0.0, (s, t) => s + t.amount),
      );
    });
  }

  double chartMax(Iterable<double> values) {
    double m = 0;
    for (final v in values) {
      if (v > m) m = v;
    }
    return m <= 0 ? 100 : m * 1.25;
  }

}

class ChartData {
  final List<double> values;
  final List<String> labels;
  ChartData(this.values, this.labels);
}

class MonthlyData {
  final String label;
  final double income;
  final double expense;
  MonthlyData(this.label, this.income, this.expense);
}
