import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

enum SubjectName {
  Trust,
  Jurisprudence,
  Islamic,
  Conflict,
  Company,
  Tort,
  Property,
  EU,
  HR,
  Contract,
  Criminal,
  Public,
  LSM,
  Undeclared,
}

enum AttendanceStatus {
  Present,
  Absent,
  Late,
}

class SubjectClass with ChangeNotifier {
  final String? subjectName;
  final String id;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? section;
  final String? topic;

  /// Now Implemented
  /// attendance status is a map of student ids as keys
  /// and their attendance status as values
  /// 1 for present
  /// 2 for late
  /// 3 for absent
  Map? attendanceStatus = {};

  SubjectClass({
    required this.id,
    required this.subjectName,
    required this.startTime,
    required this.endTime,
    required this.section,
    this.attendanceStatus,
    this.topic,
  });
  factory SubjectClass.invalid() {
    return SubjectClass(
      id: '', // Provide some default values for the properties
      subjectName: 'Invalid Subject',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      section: 'Invalid Section',
      topic: 'Invalid Topic',
      attendanceStatus: {},
    );
  }
  bool isInvalid() {
    // Define your conditions here to determine if the object is invalid or not
    // For example, you can check if the id is empty or if the subjectName is 'Invalid Subject'
    return id.isEmpty || subjectName == 'Invalid Subject';
  }

  factory SubjectClass.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic, dynamic>;
    String? name = data['subjectName'];
    String className;
    if (!name!.contains('Exam')) {
      className = name;

      DateTime start =
          DateFormat("yyyy-MM-dd hh:mm:ss a").parse(data['startTime']);
      DateTime end = DateFormat("yyyy-MM-dd hh:mm:ss a").parse(data['endTime']);
      Map attStat = {};
      if (data.containsKey('attStat')) {
        attStat = {...data['attStat']};
      }

      return SubjectClass(
        id: doc.id,
        subjectName: className,
        startTime: start,
        endTime: end,
        section: data['section'],
        topic: data['topic'] ?? 'Not Added',
        attendanceStatus: attStat,
      );
    } else {
      return SubjectClass.invalid();
    }
  }

  Map<dynamic, dynamic>? get attStat {
    return attendanceStatus;
  }

  // void addStatus(Student stud, AttendanceStatus stat) {
  //   //if the attendance status is null for stud, adds stat
  //   attStat.update(stud, (val) => stat, ifAbsent: () => stat);
  //   print(attendanceStatus.values.length.toString());
  //   notifyListeners();
  // }

  Color getColor() {
    switch (subjectName) {
      case 'Jurisprudence':
        return Color.fromARGB(255, 56, 85, 89);

      case 'Trust':
        return Color.fromARGB(255, 68, 137, 156);

      case 'Conflict':
        return Color.fromARGB(255, 37, 31, 87);

      case 'Islamic':
        return Color.fromARGB(255, 39, 59, 92);

      case 'Company':
        return Color.fromARGB(255, 50, 33, 58);

      case 'Tort':
        return Color.fromARGB(255, 56, 59, 83);

      case 'Property':
        return Color.fromARGB(255, 102, 113, 126);

      case 'EU':
        return Color.fromARGB(255, 206, 185, 146);

      case 'HR':
        return Color.fromARGB(255, 143, 173, 136);

      case 'Contract':
        return Color.fromARGB(255, 36, 79, 38);

      case 'Criminal':
        return Color.fromARGB(255, 37, 109, 27);

      case 'LSM':
        return Color.fromARGB(255, 189, 213, 234);

      case 'Public':
        return Color.fromARGB(255, 201, 125, 96);
      case 'Islamiat':
        return Color.fromARGB(255, 102, 113, 126);
      case 'Maths':
        return Color.fromARGB(255, 189, 213, 234);
      case 'Urdu':
        return Color.fromARGB(255, 201, 125, 96);
      case 'English':
        return Color.fromARGB(255, 206, 185, 146);
      case 'Computer':
        return Color.fromARGB(255, 39, 59, 92);
      case 'Biology':
        return Color.fromARGB(255, 143, 173, 136);
      default:
        return Colors.black;
    }
  }

  // String getAllPresent() {
  //   final studs = attendanceStatus.keys.toList();
  //   final stats = attendanceStatus.values.toList();
  //   int allP = 0;
  //   for (var i = 0; i < studs.length; i++) {
  //     if (stats[i] == AttendanceStatus.Present) {
  //       allP++;
  //     }
  //   }
  //   return allP.toString();
  // }

  // List<String> get allStudIDs {
  //   return regStuds;
  // }
}
