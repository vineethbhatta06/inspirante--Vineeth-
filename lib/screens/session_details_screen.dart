import 'package:flutter/material.dart';

import '../backend/database_helper.dart';
import '../models/attendance_record.dart';
import '../models/student.dart';

class SessionDetailsScreen extends StatefulWidget {

  final int sessionId;
  final String sessionDate;

  const SessionDetailsScreen({
    super.key,
    required this.sessionId,
    required this.sessionDate,
  });

  @override
  State<SessionDetailsScreen> createState() =>
      _SessionDetailsScreenState();
}

class _SessionDetailsScreenState
    extends State<SessionDetailsScreen> {

  final DatabaseHelper dbHelper =
      DatabaseHelper();

  List<Student> students = [];

  Map<int, bool> attendanceMap = {};

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    loadData();
  }

  Future<void> loadData() async {

    final loadedStudents =
        await dbHelper.getAllStudents();

    final records =
        await dbHelper.getAttendanceForSession(
      widget.sessionId,
    );

    for (AttendanceRecord record
        in records) {

      attendanceMap[record.studentId] =
          record.isPresent;
    }

    setState(() {

      students = loadedStudents;

      isLoading = false;
    });
  }

  Future<void> saveChanges() async {

    for (Student student
        in students) {

      await dbHelper.updateAttendance(
        widget.sessionId,
        student.id,
        attendanceMap[student.id] ??
            true,
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

        title: Text(
          widget.sessionDate,
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

                  child:
                      ListView.builder(

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

                        onChanged:
                            (value) {

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
                          saveChanges,

                      child:
                          const Text(
                        'Save Changes',
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}