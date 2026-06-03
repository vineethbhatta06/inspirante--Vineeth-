import 'package:flutter/material.dart';

import '../backend/database_helper.dart';
import '../models/student.dart';

class StudentDetailsScreen
    extends StatefulWidget {

  final Student student;

  const StudentDetailsScreen({
    super.key,
    required this.student,
  });

  @override
  State<StudentDetailsScreen>
      createState() =>
          _StudentDetailsScreenState();
}

class _StudentDetailsScreenState
    extends State<StudentDetailsScreen> {

  final DatabaseHelper dbHelper =
      DatabaseHelper();

  bool isLoading = true;

  int totalSessions = 0;
  int presentCount = 0;
  double percentage = 0;

  List<Map<String, dynamic>>
      history = [];

  @override
  void initState() {

    super.initState();

    loadData();
  }

  Future<void> loadData() async {

    totalSessions =
        await dbHelper.getTotalSessions();

    presentCount =
        await dbHelper.getPresentCount(
      widget.student.id,
    );

    percentage =
        await dbHelper
            .getAttendancePercentage(
      widget.student.id,
    );

    history =
        await dbHelper
            .getStudentAttendanceHistory(
      widget.student.id,
    );

    setState(() {

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(
          widget.student.name,
        ),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Column(

              children: [

                Card(

                  margin:
                      const EdgeInsets.all(
                    12,
                  ),

                  child: Padding(

                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(
                          'Total Sessions: $totalSessions',
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          'Present Count: $presentCount',
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          'Attendance Percentage: ${percentage.toStringAsFixed(1)}%',
                          style:
                              const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Padding(

                  padding:
                      EdgeInsets.all(8),

                  child: Text(
                    'Attendance History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                Expanded(

                  child:
                      ListView.builder(

                    itemCount:
                        history.length,

                    itemBuilder:
                        (context, index) {

                      final item =
                          history[index];

                      final present =
                          item[
                                  'is_present'] ==
                              1;

                      return ListTile(

                        leading: Icon(

                          present
                              ? Icons.check_circle
                              : Icons.cancel,

                          color:
                              present
                                  ? Colors.green
                                  : Colors.red,
                        ),

                        title: Text(
                          item['date'],
                        ),

                        subtitle: Text(
                          present
                              ? 'Present'
                              : 'Absent',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}