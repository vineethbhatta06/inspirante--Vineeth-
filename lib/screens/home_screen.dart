import 'package:flutter/material.dart';

import '../models/student.dart';
import '../backend/database_helper.dart';

import 'attendance_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final DatabaseHelper dbHelper = DatabaseHelper();

  List<Student> students = [];

  Map<int, double> percentages = {};

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    loadData();
  }

  Future<void> loadData() async {

    setState(() {

      isLoading = true;
    });

    final loadedStudents =
        await dbHelper.getAllStudents();

    Map<int, double> loadedPercentages = {};

    for (Student student in loadedStudents) {

      final percentage =
          await dbHelper.getAttendancePercentage(
            student.id,
          );

      loadedPercentages[student.id] =
          percentage;
    }

    setState(() {

      students = loadedStudents;

      percentages = loadedPercentages;

      isLoading = false;
    });
  }

  Color getPercentageColor(double percentage) {

    if (percentage >= 75) {
      return Colors.green;
    }

    if (percentage >= 50) {
      return Colors.orange;
    }

    return Colors.red;
  }

  double getClassAverage() {

    if (percentages.isEmpty) {
      return 0;
    }

    double total = 0;

    for (double value
        in percentages.values) {

      total += value;
    }

    return total /
        percentages.length;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Attendance Manager',
        ),

        actions: [

          IconButton(

            icon: const Icon(
              Icons.history,
            ),

            onPressed: () async {

              await Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      const HistoryScreen(),
                ),
              );

              await loadData();
            },
          ),
        ],
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
                          'Total Students: ${students.length}',
                          style:
                              const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          'Class Average Attendance: ${getClassAverage().toStringAsFixed(1)}%',
                          style:
                              const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(

                  child:
                      ListView.builder(

                    itemCount:
                        students.length,

                    itemBuilder:
                        (context, index) {

                      final student =
                          students[index];

                      final percentage =
                          percentages[
                                  student.id] ??
                              0;

                      return Card(

                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        child: ListTile(

                          leading:
                              CircleAvatar(

                            child: Text(
                              student.id
                                  .toString(),
                            ),
                          ),

                          title: Text(
                            student.name,
                          ),

                          subtitle: Text(

                            'Attendance: ${percentage.toStringAsFixed(1)}%',

                            style:
                                TextStyle(

                              color:
                                  getPercentageColor(
                                percentage,
                              ),

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

      floatingActionButton:
          FloatingActionButton(

        onPressed: () async {

          await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  const AttendanceScreen(),
            ),
          );

          await loadData();
        },

        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}