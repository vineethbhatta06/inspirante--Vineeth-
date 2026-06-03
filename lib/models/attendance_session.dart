class AttendanceSession {
  final int id;
  final String date;

  AttendanceSession({
    required this.id,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
    };
  }

  factory AttendanceSession.fromMap(Map<String, dynamic> map) {
    return AttendanceSession(
      id: map['id'],
      date: map['date'],
    );
  }
}