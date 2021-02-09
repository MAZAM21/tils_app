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
  final String subjectName;
  final String id;
  final DateTime startTime;
  final String section;
  final String topic;
  Map<String, dynamic> attendanceStatus = {};

  SubjectClass({
    @required this.id,
    @required this.subjectName,
    @required this.startTime,
    @required this.section,
    this.attendanceStatus,
    this.topic,
  });

  factory SubjectClass.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data();

    return SubjectClass(
      id: doc.id,
      subjectName: data['subjectName'],
      startTime: DateFormat("yyyy-MM-dd hh:mm:ss a").parse(data['startTime']),
      section: data['section'],
      topic: data['topic'] ?? 'Not Added',
    );
  }

  Map<dynamic, dynamic> get attStat {
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
        break;
      case 'Trust':
        return Color.fromARGB(255, 68, 137, 156);
        break;
      case 'Conflict':
        return Color.fromARGB(255, 37, 31, 87);
        break;
      case 'Islamic':
        return Color.fromARGB(255, 39, 59, 92);
        break;
      case 'Company':
        return Color.fromARGB(255, 50, 33, 58);
        break;
      case 'Tort':
        return Color.fromARGB(255, 56, 59, 83);
        break;
      case 'Property':
        return Color.fromARGB(255, 102, 113, 126);
        break;
      case 'EU':
        return Color.fromARGB(255, 206, 185, 146);
        break;
      case 'HR':
        return Color.fromARGB(255, 143, 173, 136);
        break;
      case 'Contract':
        return Color.fromARGB(255, 36, 79, 38);
        break;
      case 'Criminal':
        return Color.fromARGB(255, 37, 109, 27);
        break;
      case 'LSM':
        return Color.fromARGB(255, 189, 213, 234);
        break;
      case 'Public':
        return Color.fromARGB(255, 201, 125, 96);
        break;
      default:
        return Colors.black;
    }
  }

  SubjectName setSubject(String sub) {
    switch (sub) {
      case 'Jurisprudence':
        return SubjectName.Jurisprudence;
        break;
      case 'Trust':
        return SubjectName.Trust;
        break;
      case 'Conflict':
        return SubjectName.Conflict;
        break;
      case 'Islamic':
        return SubjectName.Islamic;
        break;
      case 'Company':
        return SubjectName.Company;
        break;
      case 'Tort':
        return SubjectName.Tort;
        break;
      case 'Property':
        return SubjectName.Property;
        break;
      case 'EU':
        return SubjectName.EU;
        break;
      case 'HR':
        return SubjectName.HR;
        break;
      case 'Contract':
        return SubjectName.Contract;
        break;
      case 'Criminal':
        return SubjectName.Criminal;
        break;
      case 'LSM':
        return SubjectName.LSM;
        break;
      case 'Public':
        return SubjectName.Public;
        break;
      default:
        return SubjectName.Undeclared;
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
