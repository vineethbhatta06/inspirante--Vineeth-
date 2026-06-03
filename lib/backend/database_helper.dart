import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/student.dart';
import '../models/attendance_session.dart';
import '../models/attendance_record.dart';

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

    // Students table
    await db.execute('''
      CREATE TABLE students(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    // Attendance sessions table
    await db.execute('''
      CREATE TABLE attendance_sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL
      )
    ''');

    // Attendance records table
    await db.execute('''
      CREATE TABLE attendance_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER,
        student_id INTEGER,
        is_present INTEGER,
        FOREIGN KEY(session_id) REFERENCES attendance_sessions(id),
        FOREIGN KEY(student_id) REFERENCES students(id)
      )
    ''');

    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(Database db) async {

    // Insert students
    List<Student> students = [
      Student(id: 1, name: 'Asha Rao'),
      Student(id: 2, name: 'Ravi Shetty'),
      Student(id: 3, name: 'Meera Nair'),
      Student(id: 4, name: 'Kiran Bhat'),
      Student(id: 5, name: 'Divya Kamath'),
      Student(id: 6, name: 'Suresh Pai'),
      Student(id: 7, name: 'Ananya Hegde'),
      Student(id: 8, name: 'Rohan Shenoy'),
      Student(id: 9, name: 'Nisha Prabhu'),
      Student(id: 10, name: 'Tejas Mallya'),
      Student(id: 11, name: 'Priya Bangera'),
    ];

    for (Student student in students) {

      await db.insert(
        'students',
        student.toMap(),
      );
    }

    // Insert attendance sessions
    List<AttendanceSession> sessions = [
      AttendanceSession(id: 1, date: '2026-05-28'),
      AttendanceSession(id: 2, date: '2026-05-29'),
      AttendanceSession(id: 3, date: '2026-05-30'),
      AttendanceSession(id: 4, date: '2026-05-31'),
      AttendanceSession(id: 5, date: '2026-06-01'),
    ];

    for (AttendanceSession session in sessions) {

      await db.insert(
        'attendance_sessions',
        session.toMap(),
      );
    }

    // Insert attendance records
    List<AttendanceRecord> records = [];

    for (AttendanceSession session in sessions) {

      for (Student student in students) {

        bool isPresent =
            (student.id + session.id) % 3 != 0;

        records.add(
          AttendanceRecord(
             id: null,
            sessionId: session.id,
            studentId: student.id,
            isPresent: isPresent,
          ),
        );
      }
    }

    for (AttendanceRecord record in records) {

      await db.insert(
        'attendance_records',
        record.toMap(),
      );
    }
  }

  Future<List<Student>> getAllStudents() async {

    try {

      final db = await database;

      final List<Map<String, dynamic>> maps =
          await db.query('students');

      return List.generate(
        maps.length,
        (index) => Student.fromMap(maps[index]),
      );

    } catch (e) {

      log('Error fetching students: $e');

      return [];
    }
  }

  Future<List<AttendanceSession>> getAllSessions() async {

    try {

      final db = await database;

      final List<Map<String, dynamic>> maps =
          await db.query('attendance_sessions');

      return List.generate(
        maps.length,
        (index) => AttendanceSession.fromMap(maps[index]),
      );

    } catch (e) {

      log('Error fetching sessions: $e');

      return [];
    }
  }
   
  String testMethod() {
  return "hello";
  }

  Future<double> getAttendancePercentage(
int studentId,) async {

  try {

    final db = await database;

    final totalSessionsResult =
        await db.rawQuery(
      '''
      SELECT COUNT(*) as count
      FROM attendance_sessions
      ''',
    );

    int totalSessions =
        totalSessionsResult.first['count']
            as int;

    final presentResult =
        await db.rawQuery(
      '''
      SELECT COUNT(*) as count
      FROM attendance_records
      WHERE student_id = ?
      AND is_present = 1
      ''',
      [studentId],
    );

    int presentCount =
        presentResult.first['count']
            as int;

    if (totalSessions == 0) {
      return 0;
    }

    return (
      presentCount / totalSessions
    ) * 100;

  } catch (e) {

    return 0;
  }
}

     Future<int> createSession(String date) async {

  final db = await database;

  return await db.insert(
    'attendance_sessions',
    {
      'date': date,
    },
  );
}

Future<void> saveAttendanceRecord(
  int sessionId,
  int studentId,
  bool isPresent,
) async {

  final db = await database;

  await db.insert(
    'attendance_records',
    {
      'session_id': sessionId,
      'student_id': studentId,
      'is_present': isPresent ? 1 : 0,
    },
  );
}

Future<List<AttendanceRecord>>
    getAttendanceForSession(
  int sessionId,
) async {

  final db = await database;

  final result = await db.query(
    'attendance_records',
    where: 'session_id = ?',
    whereArgs: [sessionId],
  );

  return result
      .map(
        (e) => AttendanceRecord.fromMap(e),
      )
      .toList();
}

Future<void> updateAttendance(
  int sessionId,
  int studentId,
  bool isPresent,
) async {

  final db = await database;

  await db.update(
    'attendance_records',
    {
      'is_present': isPresent ? 1 : 0,
    },
    where:
        'session_id = ? AND student_id = ?',
    whereArgs: [
      sessionId,
      studentId,
    ],
  );
}

   Future<bool> sessionExists(
  String date,
) async {

  final db = await database;

  final result = await db.query(
    'attendance_sessions',
    where: 'date = ?',
    whereArgs: [date],
  );

  return result.isNotEmpty;
}
  
}