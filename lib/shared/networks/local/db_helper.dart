import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/transaction_model.dart';

class DbHelper {
  static Database? _db;

  static Future<Database> get database async => _db ??= await _init();

  static Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'expense_tracker.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            is_expense INTEGER NOT NULL,
            category TEXT NOT NULL,
            note TEXT,
            date INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  static Future<int> insert(TransactionModel t) async {
    final db = await database;
    return db.insert('transactions', t.toMap()..remove('id'));
  }

  static Future<List<TransactionModel>> getAll() async {
    final db = await database;
    final rows = await db.query('transactions', orderBy: 'date DESC');
    return rows.map(TransactionModel.fromMap).toList();
  }

  static Future<int> update(TransactionModel t) async {
    final db = await database;
    return db.update('transactions', t.toMap(), where: 'id = ?', whereArgs: [t.id]);
  }

  static Future<int> delete(int id) async {
    final db = await database;
    return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}