import 'package:flutter/material.dart';

import '../backend/database_helper.dart';
import '../models/student.dart';

class AttendanceScreen extends StatefulWidget {

  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState
    extends State<AttendanceScreen> {

  final DatabaseHelper dbHelper =
      DatabaseHelper();

  List<Student> students = [];

  Map<int, bool> attendanceMap = {};

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    loadStudents();
  }

  Future<void> loadStudents() async {

    final loadedStudents =
        await dbHelper.getAllStudents();

    for (var student in loadedStudents) {

      attendanceMap[student.id] = true;
    }

    setState(() {

      students = loadedStudents;

      isLoading = false;
    });
  }

  Future<void> saveAttendance() async {

    String today =
        DateTime.now()
            .toIso8601String()
            .split('T')
            .first;

    int sessionId =
        await dbHelper.createSession(
      today,
    );

    for (var student in students) {

      await dbHelper.saveAttendanceRecord(
        sessionId,
        student.id,
        attendanceMap[student.id] ?? true,
      );
    }

    if (mounted) {

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Mark Attendance',
        ),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Column(

              children: [

                Expanded(

                  child: ListView.builder(

                    itemCount:
                        students.length,

                    itemBuilder:
                        (context, index) {

                      final student =
                          students[index];

                      return CheckboxListTile(

                        title: Text(
                          student.name,
                        ),

                        value:
                            attendanceMap[
                                    student.id] ??
                                true,

                        onChanged: (
                          value,
                        ) {

                          setState(() {

                            attendanceMap[
                                    student.id] =
                                value ??
                                    true;
                          });
                        },
                      );
                    },
                  ),
                ),

                Padding(

                  padding:
                      const EdgeInsets.all(
                    16,
                  ),

                  child: SizedBox(

                    width:
                        double.infinity,

                    child:
                        ElevatedButton(

                      onPressed:
                          saveAttendance,

                      child:
                          const Text(
                        'Save Attendance',
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}