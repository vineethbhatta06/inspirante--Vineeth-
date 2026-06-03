import 'package:flutter/material.dart';

import '../models/student.dart';
import '../backend/database_helper.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final DatabaseHelper dbHelper = DatabaseHelper();

  List<Student> students = [];

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    loadStudents();
  }

  Future<void> loadStudents() async {

    final loadedStudents =
        await dbHelper.getAllStudents();

    setState(() {

      students = loadedStudents;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Attendance Manager',
        ),
      ),

      body: isLoading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : ListView.builder(

              itemCount: students.length,

              itemBuilder: (context, index) {

                final student = students[index];

                return ListTile(

                  leading: CircleAvatar(
                    child: Text(
                      student.id.toString(),
                    ),
                  ),

                  title: Text(
                    student.name,
                  ),

                  subtitle: const Text(
                    'Attendance: 0%',
                  ),
                );
              },
            ),
    );
  }
}