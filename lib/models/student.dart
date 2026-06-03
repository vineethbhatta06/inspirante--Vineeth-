class Student {
  final int id;
  final String name;

  Student({
    required this.id,
    required this.name,
  });

  // Convert Student object to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Create Student object from database Map
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
    );
  }
}