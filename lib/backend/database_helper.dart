import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static Database? _database;

  Future<Database> get database async {

    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();

    return _database!;
  }

  Future<Database> _initializeDatabase() async {

    String path = join(
      await getDatabasesPath(),
      'attendance.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(
    Database db,
    int version,
  ) async {

  }
}