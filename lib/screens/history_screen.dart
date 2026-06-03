import 'package:flutter/material.dart';

import '../backend/database_helper.dart';
import '../models/attendance_session.dart';
import 'session_details_screen.dart';

class HistoryScreen extends StatefulWidget {

  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() =>
      _HistoryScreenState();
}

class _HistoryScreenState
    extends State<HistoryScreen> {

  final DatabaseHelper dbHelper =
      DatabaseHelper();

  List<AttendanceSession> sessions =
      [];

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    loadSessions();
  }

  Future<void> loadSessions() async {

    final loadedSessions =
        await dbHelper.getAllSessions();

    loadedSessions.sort(
      (a, b) => b.id.compareTo(a.id),
    );

    setState(() {

      sessions = loadedSessions;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Attendance History',
        ),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : ListView.builder(

              itemCount:
                  sessions.length,

              itemBuilder:
                  (context, index) {

                final session =
                    sessions[index];

                return Card(

                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  child: ListTile(

                    leading:
                        const Icon(
                      Icons.calendar_today,
                    ),

                    title: Text(
                      session.date,
                    ),

                    subtitle: Text(
                      'Session ID: ${session.id}',
                    ),

                    trailing:
                        const Icon(
                      Icons.arrow_forward_ios,
                    ),

                    onTap: () async {

                      await Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                              SessionDetailsScreen(

                            sessionId:
                                session.id,

                            sessionDate:
                                session.date,
                          ),
                        ),
                      );

                      loadSessions();
                    },
                  ),
                );
              },
            ),
    );
  }
}