# Attendance Manager

## Overview

Attendance Manager is a Flutter application that allows teachers to manage student attendance records using a local SQLite database.

The application supports:

* Viewing all students and their attendance percentages
* Marking attendance for a new session
* Preventing duplicate attendance for the same day
* Viewing attendance history
* Editing attendance records from previous sessions
* Viewing detailed student attendance summaries and history

---

## Build Environment

### Flutter Version

Flutter 3.29.3

### Android SDK

* Minimum SDK: 21
* Target SDK: Flutter default configuration

### Dependencies

* sqflite
* path

Install dependencies:

flutter pub get

---

## Running the Project

1. Clone the repository

git clone <https://github.com/vineethbhatta06/inspirante--Vineeth->

2. Open the project in VS Code

3. Install dependencies

flutter pub get

4. Run the application

flutter run

Alternatively, launch an Android Emulator and press Run in Android Studio.

---

## Database Structure

The application uses SQLite with three tables:

### students

Stores student information.

Fields:

* id
* name

### attendance_sessions

Stores attendance session dates.

Fields:

* id
* date

### attendance_records

Stores attendance status for each student in a session.

Fields:

* id
* session_id
* student_id
* is_present

---

## Seed Data

The database is automatically populated during first launch.

Seeded data includes:

### Students

11 predefined students:

* Asha Rao
* Ravi Shetty
* Meera Nair
* Kiran Bhat
* Divya Kamath
* Suresh Pai
* Ananya Hegde
* Rohan Shenoy
* Nisha Prabhu
* Tejas Mallya
* Priya Bangera

### Attendance Sessions

5 predefined attendance sessions are created automatically.

### Attendance Records

Attendance records for all students are generated and inserted during database initialization.

The seed process runs only when the database is created for the first time.

---

## Features Implemented

### Teacher Features

* View all students
* View attendance percentages
* Mark attendance
* Create attendance sessions
* Edit previous attendance records
* View attendance history
* Prevent duplicate attendance for the same date

### Student Summary

* Total sessions attended
* Present count
* Attendance percentage
* Complete attendance history

---

## Known Issues 
* Student records are predefined and cannot be added or removed through the UI.
* Session deletion functionality is not implemented.

---

## Project Structure

lib/
├── backend/
│ └── database_helper.dart
├── models/
│ ├── student.dart
│ ├── attendance_session.dart
│ └── attendance_record.dart
├── screens/
│ ├── home_screen.dart
│ ├── attendance_screen.dart
│ ├── history_screen.dart
│ ├── session_details_screen.dart
│ └── student_details_screen.dart
└── main.dart
