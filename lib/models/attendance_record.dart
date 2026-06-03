class AttendanceRecord {
  final int id;
  final int sessionId;
  final int studentId;
  final bool isPresent;

  AttendanceRecord({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.isPresent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'student_id': studentId,
      'is_present': isPresent ? 1 : 0,
    };
  }

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'],
      sessionId: map['session_id'],
      studentId: map['student_id'],
      isPresent: map['is_present'] == 1,
    );
  }
}